#import "LSystemLayer.h"

#import "DrawContext.h"
#import "LSystem.h"
#import "DrawState.h"
#import "LSystemNode.h"

@implementation LSystemLayer {
    CCMenu *menu_;
    LSystemNode *lsystem_;
}

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	LSystemLayer *layer = [LSystemLayer node];
	[scene addChild: layer];
    
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
        [self setTouchEnabled:YES];
        [self showMenu];        
	}
	return self;
}

-(void) registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void) showMenu {
    if (!menu_) {
        menu_ = [CCMenu menuWithItems:nil];
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"Rules" withExtension:@"plist"];
        NSDictionary *ruleConfigs = [NSDictionary dictionaryWithContentsOfURL:url];
        
        NSArray *sortedKeys = [ruleConfigs.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

        for (NSString *ruleKey in sortedKeys) {
            CCMenuItemFont *item = [CCMenuItemFont itemWithString:ruleKey block:^(id sender) {
                NSDictionary *ruleConfig = [ruleConfigs objectForKey:ruleKey];
                menu_.visible = NO;
                [self showLSystemWithRuleConfig:ruleConfig];
            }];
            [menu_ addChild:item];
        }
        
        [menu_ alignItemsVertically];
        
        [self addChild:menu_ z:2];        
    }
    
    menu_.visible = YES;
}

-(void) showLSystemWithRuleConfig:(NSDictionary*)ruleConfig {
    // remove current lsystem
    [lsystem_ removeFromParentAndCleanup:YES];
    
    NSDictionary *rules = [ruleConfig objectForKey:@"Rules"];
    
    CGSize size = self.contentSize;
    CGSize lsysSize = size;
    
    lsystem_ = [LSystemNode nodeWithSize:lsysSize];
    lsystem_.position = ccpMult(ccpFromSize(size), 0.5); // center of layer
    lsystem_.drawOrigin = ccp(lsysSize.width/2, 0);
    lsystem_.clearColor = ccc4f(0.4, 0.4, 0.8, 1);
    lsystem_.generation = [[ruleConfig objectForKey:@"Generations"] integerValue];
    
    if (ruleConfig[@"SegmentLength"]) {
        lsystem_.segmentLength = [ruleConfig[@"SegmentLength"] floatValue];
    }
    
    if (ruleConfig[@"Angle"]) {
        lsystem_.angle = [ruleConfig[@"Angle"] floatValue];
    }
    
    [self addChild:lsystem_];
    
    [lsystem_ startWithRules:rules animate:YES];
}

-(void) saveLSystemImage {
    NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
    [[NSFileManager defaultManager] createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
    filepath = [filepath stringByAppendingPathComponent:@"Tree.png"];
    
    UIImage *img = [lsystem_ image];
    NSData *imgData = UIImagePNGRepresentation(img);
    [imgData writeToFile:filepath atomically:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (touch.tapCount == 2) {
        [self saveLSystemImage];
    } else {
        [self showMenu];
    }
    
    return YES;
}

@end
