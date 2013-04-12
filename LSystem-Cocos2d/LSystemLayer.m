#import "LSystemLayer.h"

#import "DrawContext.h"
#import "LSystem.h"
#import "DrawState.h"
#import "LSystemDebugLayer.h"
#import "LSystemNode.h"

@implementation LSystemLayer {
    NSDictionary *config_;
    CCMenu *menu_;
    CCMenu *schemeMenu_;
    LSystemNode *lsystem_;
    
    NSDictionary *currentSystem_;
    NSDictionary *currentScheme_;
    NSDictionary *currentRules_;
}

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	LSystemLayer *layer = [LSystemLayer node];
	[scene addChild: layer];
    
#if LSYSTEM_DEBUG == 1
    [scene addChild:[LSystemDebugLayer sharedDebugLayer]];
#endif
    
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
        [self setTouchEnabled:YES];
        
        config_ = [self loadConfig];
        [self showMenu];
	}
	return self;
}

-(NSDictionary*) loadConfig {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Rules" withExtension:@"plist"];
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfURL:url];
    return config;
}

-(void) showMenu {
    if (!menu_) {
        menu_ = [CCMenu menuWithItems:nil];
        
        NSDictionary *systems = config_[@"Systems"];
        
        NSArray *sortedKeys = [systems.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

        for (NSString *ruleKey in sortedKeys) {
            CCMenuItemFont *item = [CCMenuItemFont itemWithString:ruleKey block:^(id sender) {
                menu_.visible = NO;
                currentSystem_ = [systems objectForKey:ruleKey];
                [self showSchemeMenu];
            }];
            [menu_ addChild:item];
        }
        
        [menu_ alignItemsVertically];
        
        [self addChild:menu_ z:2];        
    }
    
    [schemeMenu_ removeFromParentAndCleanup:YES];
    menu_.visible = YES;
}

-(void) showSchemeMenu {
    NSAssert(currentSystem_, @"currentSystem_ should not be nil");
    
    schemeMenu_ = [CCMenu menuWithItems:nil];
    
    NSDictionary *globalSchemes = config_[@"Schemes"];
    NSDictionary *systemSchemes = currentSystem_[@"Schemes"];
    
    // get sorted array of scheme names to use as menu items
    NSMutableSet *schemeNames = [NSMutableSet set];
    [schemeNames addObjectsFromArray:globalSchemes.allKeys];
    [schemeNames addObjectsFromArray:systemSchemes.allKeys];
    NSArray *sortedKeys = [[schemeNames allObjects] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (NSString *schemeName in sortedKeys) {
        CCMenuItemFont *item = [CCMenuItemFont itemWithString:schemeName block:^(id sender) {
            schemeMenu_.visible = NO;
            
            // merge the global and system schemes
            NSMutableDictionary *scheme = [NSMutableDictionary dictionary];
            [scheme addEntriesFromDictionary:globalSchemes[schemeName]];
            [scheme addEntriesFromDictionary:systemSchemes[schemeName]];
            
            currentScheme_ = scheme;
            [self showLSystem];
        }];
        
        [schemeMenu_ addChild:item];
    }
    
    [schemeMenu_ alignItemsVertically];
    
    [self addChild:schemeMenu_ z:2];
}

-(void) showLSystem {
    [lsystem_ removeFromParentAndCleanup:YES];
    
    NSDictionary *rules = currentSystem_[@"Rules"];
    
    CGSize size = self.contentSize;
    CGSize lsysSize = size;
    
    lsystem_ = [LSystemNode nodeWithSize:lsysSize];
    lsystem_.position = ccpMult(ccpFromSize(size), 0.5); // center of layer
    lsystem_.drawOrigin = ccp(lsysSize.width/2, 0);
    lsystem_.clearColor = ccc4f(0.4, 0.4, 0.8, 1);
    
    // first setup using root config for system
    [self setupLSystemWithScheme:currentSystem_];
    
    // setup using merged scheme config
    [self setupLSystemWithScheme:currentScheme_];
    
    [self addChild:lsystem_];
    currentRules_ = rules;
    [self startLSystemWithCurrentRules];
}

-(void) startLSystemWithCurrentRules {
    [lsystem_ startWithRules:currentRules_ animate:YES];
}

-(void) setupLSystemWithScheme:(NSDictionary*)schemeConfig {
    NSArray *reserved = [NSArray arrayWithObjects:@"Rules", @"Schemes", nil];
    
    for (NSString *key in schemeConfig.allKeys) {
        if ([reserved containsObject:key])
            continue;
        
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
        
        CCLOG(@"setting value for %@", key);
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

-(void) registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
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
