#import "LSystemNode.h"

#import "LeafDrawCommand.h"
#import "LSystem.h"
#import "RenderTextureSegmentDrawer.h"


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
        self.contentSize = size;
        self.anchorPoint = ccp(0.5,0.5);
        self.generation = 6;
        self.segmentLength = size.height / 10;
        self.angle = 20;
        
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
    
    // render segments to a CCRenderTexture
    RenderTextureSegmentDrawer *segDrawer = [[RenderTextureSegmentDrawer alloc] init];
    segDrawer.rt = rt_;
    
    // create LSystem
    lsys_ = [[LSystem alloc] init];
    lsys_.segment = segDrawer;
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

-(void) update:(ccTime)dt {
    NSAssert(started_, @"LSystemNode not started");
    
    // animate drawing of l-system
    if (time_ < duration_) {
        time_ += dt;
        
        [rt_ clear:self.clearColor.r g:self.clearColor.g b:self.clearColor.b a:self.clearColor.a];
        
        [lsys_ draw:self.drawOrigin generation:self.generation time:time_ ease:-1];
    }
}

@end
