#import "LSystemLayer.h"

#import "DrawContext.h"
#import "LSystem.h"
#import "DrawState.h"
#import "LSystemNode.h"

@implementation LSystemLayer {
    CCMenu *menu_;
    CCMenu *schemeMenu_;
    LSystemNode *lsystem_;
    NSDictionary *currentRules_;
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
                [self showLSystemWithConfig:ruleConfig];
            }];
            [menu_ addChild:item];
        }
        
        [menu_ alignItemsVertically];
        
        [self addChild:menu_ z:2];        
    }
    
    [schemeMenu_ removeFromParentAndCleanup:YES];
    menu_.visible = YES;
}

-(void) showSchemeMenuForSchemes:(NSDictionary*)schemes {
    schemeMenu_ = [CCMenu menuWithItems:nil];
//    schemeMenu_.anchorPoint = ccp(0,1);
    schemeMenu_.position = ccp(self.contentSize.width/10,self.contentSize.height/2);
    
    NSArray *sortedKeys = [schemes.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (NSString *schemeName in sortedKeys) {
        CCMenuItemFont *item = [CCMenuItemFont itemWithString:schemeName block:^(id sender) {
            NSDictionary *schemeConfig = [schemes objectForKey:schemeName];
            [self setupLSystemWithScheme:schemeConfig];
            [self startLSystemWithCurrentRules];
        }];
        
        [schemeMenu_ addChild:item];
    }
    
    [schemeMenu_ alignItemsVertically];
    
    [self addChild:schemeMenu_ z:2];
}

-(void) showLSystemWithConfig:(NSDictionary*)config {
    // remove current lsystem
    [lsystem_ removeFromParentAndCleanup:YES];
    
    NSDictionary *rules = [config objectForKey:@"Rules"];
    
    CGSize size = self.contentSize;
    CGSize lsysSize = size;
    
    lsystem_ = [LSystemNode nodeWithSize:lsysSize];
    lsystem_.position = ccpMult(ccpFromSize(size), 0.5); // center of layer
    lsystem_.drawOrigin = ccp(lsysSize.width/2, 0);
    lsystem_.clearColor = ccc4f(0.4, 0.4, 0.8, 1);
    
    if (config[@"Generations"]) {
        lsystem_.generation = [[config objectForKey:@"Generations"] integerValue];
    }
    
    if (config[@"SegmentLength"]) {
        lsystem_.segmentLength = [config[@"SegmentLength"] floatValue];
    }
    
    if (config[@"Angle"]) {
        lsystem_.angle = [config[@"Angle"] floatValue];
    }
    
    NSDictionary *schemes = config[@"Schemes"];
    
    if (schemes) {
        NSString *schemeName = config[@"DefaultScheme"] ? config[@"DefaultScheme"] : [schemes.allKeys objectAtIndex:0];
        CCLOG(@"Setting up LSystemNode with scheme %@", schemeName);
        NSDictionary *segmentConfig = schemes[schemeName];
        [self setupLSystemWithScheme:segmentConfig];
        
        [schemeMenu_ removeFromParentAndCleanup:YES];
        [self showSchemeMenuForSchemes:schemes];
    }
    
    [self addChild:lsystem_];
    currentRules_ = rules;
    [self startLSystemWithCurrentRules];
}

-(void) startLSystemWithCurrentRules {
    [lsystem_ startWithRules:currentRules_ animate:YES];
}

-(void) setupLSystemWithScheme:(NSDictionary*)schemeConfig {
    for (NSString *key in schemeConfig.allKeys) {
        id value;
        
        if ([key isEqualToString:@"leafColor"]) {
            NSArray *components = [schemeConfig[@"leafColor"] componentsSeparatedByString:@","];
            CGFloat r = [[components objectAtIndex:0] floatValue];
            CGFloat g = [[components objectAtIndex:1] floatValue];
            CGFloat b = [[components objectAtIndex:2] floatValue];
            CGFloat a = [[components objectAtIndex:3] floatValue];
            ccColor4B c = ccc4(r, g, b, a);
            value = [NSValue valueWithBytes:&c objCType:@encode(ccColor4B)];
        } else {
            value = schemeConfig[key];
        }
        
        [lsystem_ setValue:value forKey:key];
    }
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
