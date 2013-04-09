#import "LSystemNode.h"

#import "LeafDrawCommand.h"

@implementation LSystemNode {
    CGPoint pos_;
    CGFloat duration_;
    CGFloat time_;
    LSystem *lsys_;
    CCRenderTexture *rt_;
    BOOL started_;
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
        self.baseWidth = size.width / 1000;
        self.widthScaleFactor = 1.2;
        
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
    leafCommand.rt = rt_;
    lsys_.commands = [NSDictionary dictionaryWithObjectsAndKeys:leafCommand, @"L", nil];

    if (animate) {
        // find duration required for drawing l-system
        duration_ = [lsys_ duration:self.generation];
        CCLOG(@"Drawing %d generations with duration %f", self.generation, duration_);
        time_ = 0;
        started_ = YES;
        
        [self scheduleUpdate];
    } else {
        [rt_ clear:self.clearColor.r g:self.clearColor.g b:self.clearColor.b a:self.clearColor.a];
        [lsys_ draw:self.drawOrigin generation:self.generation];
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
        
        [rt_ clear:self.clearColor.r g:self.clearColor.g b:self.clearColor.b a:self.clearColor.a];
        
        [lsys_ draw:self.drawOrigin generation:self.generation time:time_ ease:-1];
    }
}

#pragma mark Segments

-(CGFloat) widthForGeneration:(NSInteger)generation {
    return self.baseWidth + (self.baseWidth * generation * self.widthScaleFactor);
}

-(void) segmentFrom:(CGPoint)from to:(CGPoint)to generation:(NSInteger)generation time:(CGFloat)time identifier:(NSInteger)identifier {
    [rt_ begin];
    
//    glBlendFunc(GL_ONE,GL_ZERO);
    
    CGFloat generationWidth = [self widthForGeneration:generation];
    CGFloat width = generationWidth;
    
    //    CCLOG(@"id=%d, generation=%d, time=%f, width=%f", identifier, generation, time, width);
    
//    ccColor4F c = ccc4f(0.5, 0.2 + (1.0 / (generation + 1) * 0.8), 0.3, 1);
    ccColor4F c = ccc4f(0.5, 0.4, 0.3, 1);
    
    ccDrawColor4F(c.r, c.g, c.b, c.a);
    glLineWidth(width * CC_CONTENT_SCALE_FACTOR());
    ccDrawLine(from, to);
    
//    ccDrawColor4F(1, 1, 1, 1);
//    ccPointSize(2);
//    ccDrawPoint(to);

    [self drawLeavesFrom:from to:to];
    
    [rt_ end];
}

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
    ccPointSize(leafSize);
    ccDrawColor4B(_leafColor.r, _leafColor.g, _leafColor.b, _leafColor.a);
    ccDrawPoint(leafPoint);
}

-(void) drawTriangleLeafAt:(CGPoint)leafPoint size:(CGFloat)leafSize direction:(CGPoint)dir {
    // triangle
    CGPoint vertices[] = {
        ccpAdd(leafPoint, ccpMult(ccpPerp(dir), leafSize)),
        ccpAdd(leafPoint, ccpMult(ccpPerp(dir), -leafSize)),
        ccpAdd(leafPoint, ccpMult(dir, leafSize*2))
    };
    ccColor4F c = [self varyLeafColor:ccc4FFromccc4B(_leafColor)];
    ccDrawSolidPoly(vertices, 3, c);
    
    // triangle outline
    glLineWidth(1*CC_CONTENT_SCALE_FACTOR());
    ccColor4F outlineColor = [self darkenLeafColor:c];
    ccDrawColor4F(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a);
    ccDrawPoly(vertices, 3, YES);
}

-(ccColor4F) varyLeafColor:(ccColor4F)color {
    const CGFloat v = 0.1;
    return ccc4f(color.r+CCRANDOM_MINUS1_1()*v, color.g+CCRANDOM_MINUS1_1()*v, color.b+CCRANDOM_MINUS1_1()*v, color.a);
}

-(ccColor4F) darkenLeafColor:(ccColor4F)color {
    const CGFloat darkenFactor = 0.8;
    return ccc4f(color.r*darkenFactor, color.g*darkenFactor, color.b*darkenFactor, 1);
}

@end
