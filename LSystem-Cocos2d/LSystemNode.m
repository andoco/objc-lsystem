#import "LSystemNode.h"

#import "LeafDrawCommand.h"

static const ccColor4B LSystemLeafColorSummer = {50, 100, 50, 150}; // green
static const ccColor4B LSystemLeafColorSpring = {150, 50, 50, 50}; // pink
static const ccColor4B LSystemLeafColorAutumn = {60, 30, 10, 50}; // red-brown

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
        self.leavesPerSegment = 5;
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
    
    ccColor4F c = ccc4f(0.5, 0.2 + (1.0 / (generation + 1) * 0.8), 0.3, 1);
    
    ccDrawColor4F(c.r, c.g, c.b, c.a);
    glLineWidth(width * CC_CONTENT_SCALE_FACTOR());
    ccDrawLine(from, to);
    
//    ccDrawColor4F(1, 1, 1, 1);
//    ccPointSize(2);
//    ccDrawPoint(to);
    
    for (int i=0; i < self.leavesPerSegment; i++) {
        
        CGPoint diff = ccpSub(to, from);
        CGPoint leafDelta = ccp(diff.y*CCRANDOM_0_1(), 5*CCRANDOM_MINUS1_1());
        leafDelta = ccpRotate(leafDelta, ccpNormalize(diff));
        CGPoint leafPoint = ccpAdd(from, leafDelta);
        
        CGFloat leafSize = self.maxLeafSize * CCRANDOM_0_1();
        ccPointSize(leafSize);
        ccDrawColor4B(_leafColor.r, _leafColor.g, _leafColor.b, _leafColor.a);
        ccDrawPoint(leafPoint);
    }
    
    [rt_ end];
}

@end
