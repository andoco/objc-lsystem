#import "LSystemNode.h"

#import "GraphPoint.h"
#import "LeafDrawCommand.h"
#import "LSystemDebugLayer.h"

@implementation LSystemNode {
    CGPoint pos_;
    CGFloat duration_;
    CGFloat time_;
    LSystem *lsys_;
    CCRenderTexture *rt_;
    BOOL started_;
    
    NSMutableDictionary *points_;
    
    CCDrawNode *drawNode_;
}

+(id) nodeWithSize:(CGSize)size {
    return [[self alloc] initWithSize:size];
}

-(id) initWithSize:(CGSize)size {
    if ((self = [super init])) {
        // node
        self.contentSize = size;
        self.anchorPoint = ccp(0.5,0.5);
        
        // lsystem
        self.generation = 6;
        self.segmentLength = size.height / 10;
        self.angle = 20;
        
        // segments
        self.minSegmentSize = 1;
        self.generationSizeFactor = 0.4;
        self.depthSizeFactor = 0.3;
        
        // leaves
        self.drawMode = LSystemNodeLeafDrawModeTriangles;
        self.leavesPerSegment = 1;
        self.leafColor = LSystemLeafColorSummer;
        self.maxLeafSize = size.height / 100;
        
        CGPoint centre = ccpMult(ccpFromSize(size), 0.5);
        self.drawOrigin = centre;
        
        self.clearColor = ccc4f(0, 0, 0, 0);
        
        rt_ = [CCRenderTexture renderTextureWithWidth:size.width height:size.height];
        rt_.anchorPoint = ccp(0.5,0.5);
        rt_.position = centre;
        [self addChild:rt_];
        
        points_ = [NSMutableDictionary dictionary];
        drawNode_ = [CCDrawNode node];
    }
    return self;
}

-(void) startWithRules:(NSDictionary*)rules animate:(BOOL)animate {
    CCLOG(@"Starting with rules %@", rules);
    
    // create LSystem
    lsys_ = [[LSystem alloc] init];
    lsys_.segment = self;
    lsys_.rules = rules;
    lsys_.segmentLength = self.segmentLength;
    lsys_.angle = self.angle;
    lsys_.cost = 0.1;
    
    LeafDrawCommand *leafCommand = [[LeafDrawCommand alloc] init];
    leafCommand.drawNode = drawNode_;
    lsys_.commands = [NSDictionary dictionaryWithObjectsAndKeys:leafCommand, @"L", nil];

    if (animate) {
        // find duration required for drawing l-system
        duration_ = [lsys_ duration:self.generation];
        CCLOG(@"Drawing %d generations with duration %f", self.generation, duration_);
        
        if (!started_)
            [self scheduleUpdate];
        
        time_ = 0;
        started_ = YES;
    } else {
        time_ = -1;
        [self updateLSystem];
    }
}

-(UIImage*) image {
    return [rt_ getUIImage];
}

-(void) update:(ccTime)dt {
    NSAssert(started_, @"LSystemNode not started");
    
    // animate drawing of l-system
    if (time_ < duration_) {
        time_ += dt;
        [self updateLSystem];
    }
}

-(void) updateLSystem {
#if LSYSTEM_DEBUG == 1
    [[LSystemDebugLayer sharedDebugLayer] clear];
#endif
    
    [lsys_ draw:self.drawOrigin generation:self.generation time:time_ ease:-1];

    [rt_ beginWithClear:self.clearColor.r g:self.clearColor.g b:self.clearColor.b a:self.clearColor.a];
    [drawNode_ visit];
    [rt_ end];
    [drawNode_ clear];
}

#pragma mark Graph

-(GraphPoint*) graphPointForPoint:(CGPoint)p {
    return points_[[NSValue valueWithCGPoint:p]];
}

-(void) addGraphPoint:(GraphPoint*)gp {
    points_[[NSValue valueWithCGPoint:gp.point]] = gp;
}

-(CGFloat) sizeForGeneration:(NSInteger)generation depth:(NSInteger)depth {
    return self.minSegmentSize + ((generation / self.generationSizeFactor) / ((self.depthSizeFactor * depth) + 1));
}

-(CGFloat) sizeForGraphPoint:(GraphPoint*)gp generation:(NSInteger)generation {
    return [self sizeForGeneration:generation depth:gp.depth];
}

-(void) updateGraphForPoint:(CGPoint)p1 p2:(CGPoint)p2 {
    GraphPoint *gp1 = [self graphPointForPoint:p1];
    
    if (!gp1) {
        // this is the first point in the graph
        gp1 = [GraphPoint graphPointWithPoint:p1 depth:0];
        [self addGraphPoint:gp1];
    }
    
    GraphPoint *gp2 = [GraphPoint graphPointWithPoint:p2 depth:gp1.depth+1];
    
    [self addGraphPoint:gp2];
}

#pragma mark SegmentDrawer

-(void) segmentFrom:(CGPoint)from to:(CGPoint)to generation:(NSInteger)generation time:(CGFloat)time identifier:(NSInteger)identifier {
    [self updateGraphForPoint:from p2:to];
    
    GraphPoint *gp1 = [self graphPointForPoint:from];
    GraphPoint *gp2 = [self graphPointForPoint:to];
    
    CGFloat size1 = [self sizeForGraphPoint:gp1 generation:generation];
    CGFloat size2 = [self sizeForGraphPoint:gp2 generation:generation];
    
    ccColor4F c = ccc4f(0.5, 0.4, 0.3, 1);
    
    [drawNode_ drawSegmentFrom:from to:to radius:size2*CC_CONTENT_SCALE_FACTOR() color:c];
    
    [self drawLeavesFrom:from to:to];
    
#if LSYSTEM_DEBUG == 1
    [[LSystemDebugLayer sharedDebugLayer] addSegmentLabelForPoint:to generation:generation depth:gp2.depth identifier:identifier];
#endif
}

#pragma mark Drawing

-(void) drawLeavesFrom:(CGPoint)from to:(CGPoint)to {
    CGPoint diff = ccpSub(to, from);
    CGPoint dir = ccpNormalize(diff);
    
    int numLeaves = roundf(CCRANDOM_0_1()*self.leavesPerSegment);
    
    for (int i=0; i < numLeaves; i++) {
        CGPoint leafDelta = ccp(diff.y*CCRANDOM_0_1(), 5*CCRANDOM_MINUS1_1());
        leafDelta = ccpRotate(leafDelta, dir);
        CGPoint leafPoint = ccpAdd(from, leafDelta);
        CGFloat leafSize = self.maxLeafSize * CCRANDOM_0_1();
        
        switch (self.drawMode) {
            case LSystemNodeLeafDrawModePoints:
                [self drawPointLeafAt:leafPoint size:leafSize];
                break;
            case LSystemNodeLeafDrawModeTriangles:
                [self drawTriangleLeafAt:leafPoint size:leafSize direction:dir];
                break;
            default:
                break;
        }
    }    
}

-(void) drawPointLeafAt:(CGPoint)leafPoint size:(CGFloat)leafSize {
    ccColor4F c = [self varyLeafColor:ccc4FFromccc4B(_leafColor)];
    [drawNode_ drawDot:leafPoint radius:leafSize color:c];
}

-(void) drawTriangleLeafAt:(CGPoint)leafPoint size:(CGFloat)leafSize direction:(CGPoint)dir {
    // triangle
    CGPoint vertices[] = {
        ccpAdd(leafPoint, ccpMult(ccpPerp(dir), leafSize)),
        ccpAdd(leafPoint, ccpMult(ccpPerp(dir), -leafSize)),
        ccpAdd(leafPoint, ccpMult(dir, leafSize*2))
    };
    
    ccColor4F c = [self varyLeafColor:ccc4FFromccc4B(_leafColor)];
    ccColor4F outlineColor = [self darkenLeafColor:c];
    
    [drawNode_ drawPolyWithVerts:vertices count:3 fillColor:c borderWidth:1*CC_CONTENT_SCALE_FACTOR() borderColor:outlineColor];
}

-(ccColor4F) varyLeafColor:(ccColor4F)color {
    const CGFloat v = 0.1;
    return ccc4f(
         clampf(color.r+CCRANDOM_MINUS1_1()*v, 0, 1),
         clampf(color.g+CCRANDOM_MINUS1_1()*v, 0, 1),
         clampf(color.b+CCRANDOM_MINUS1_1()*v, 0, 1),
         color.a
     );
}

-(ccColor4F) darkenLeafColor:(ccColor4F)color {
    const CGFloat darkenFactor = 0.8;
    return ccc4f(color.r*darkenFactor, color.g*darkenFactor, color.b*darkenFactor, 1);
}

@end
