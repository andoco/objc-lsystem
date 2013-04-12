#import "LSystemDebugLayer.h"

static LSystemDebugLayer *sharedDebugLayer;

@implementation LSystemDebugLayer {
    CCRenderTexture *rt_;
}

+(void) initialize {
    static BOOL initialized = NO;
    if (!initialized) {
        initialized = YES;
        sharedDebugLayer = [LSystemDebugLayer node];
    }
}

+(id) sharedDebugLayer {
    return sharedDebugLayer;
}

- (id)init
{
    self = [super init];
    if (self) {
        CGSize s = self.contentSize;
        rt_ = [CCRenderTexture renderTextureWithWidth:s.width height:s.height];
        rt_.anchorPoint = ccp(0.5,0.5);
        rt_.position = ccpMult(ccpFromSize(self.contentSize), 0.5);
        [self addChild:rt_];
    }
    return self;
}

-(void) clear {
    [rt_ clear:0 g:0 b:0 a:0];
}

-(void) addSegmentLabelForPoint:(CGPoint)point generation:(NSInteger)generation depth:(NSUInteger)depth identifier:(NSInteger)identifier {
    [rt_ begin];

    ccDrawColor4F(1, 1, 1, 1);
    ccPointSize(2);
    ccDrawPoint(point);

    CCLabelTTF *lbl = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"id=%d,g=%d,d=%d", identifier, generation, depth] fontName:@"Arial" fontSize:10];
    lbl.anchorPoint = ccp(0,0.5);
    lbl.position = ccp(point.x + 5, point.y);
    [lbl visit];
    
    [rt_ end];
}

@end
