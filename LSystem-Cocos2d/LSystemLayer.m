//
//  LSystemLayer.m
//  LSystem
//
//  Created by Andrew O'Connor on 07/04/2012.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "LSystemLayer.h"

#import "DrawContext.h"
#import "LSystem.h"
#import "DrawState.h"
#import "LSystemNode.h"
#import "RenderTextureSegmentDrawer.h"

@interface LSystemLayer () {
    
}

@property (nonatomic, retain) CCMenu *menu;
@property (nonatomic, retain) LSystemNode *lsystem;

@end

// LSystemLayer implementation
@implementation LSystemLayer

@synthesize menu;
@synthesize lsystem;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LSystemLayer *layer = [LSystemLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
        self.isTouchEnabled = YES;
        
        [self showMenu];
	}
	return self;
}

-(void) registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [menu release];
	[super dealloc];
}

-(NSDictionary*) systemRules {
    NSDictionary *straight = [NSDictionary dictionaryWithObjectsAndKeys:@"FFF", @"1", nil];
    NSDictionary *bend = [NSDictionary dictionaryWithObjectsAndKeys:@"FF-1", @"1", nil];
    NSDictionary *branches = [NSDictionary dictionaryWithObjectsAndKeys:@"FF-[1]++F+F", @"1", nil];
    NSDictionary *moreBranches = [NSDictionary dictionaryWithObjectsAndKeys:@"FF-[1]++F+F+1", @"1", nil];
    NSDictionary *elaborate = [NSDictionary dictionaryWithObjectsAndKeys:@"FF[-2]3[+3]", @"1", @"FF+F-F-F[FFF3][+3]-F-F3", @"2", @"FF-F+F+F[2][-2]+F+F2", @"3", nil];
    
    NSDictionary *gnarled = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"FF[++FF[2][+FF2]][-FF3]", @"1",
                             @"F-F-F+[2]F+F+F+F+>[2]", @"2",
                             @"F+F+F-[2]F-F-F-F->[2]", @"3",
                             nil];
    
    NSDictionary *crooked = [NSDictionary dictionaryWithObjectsAndKeys:@"F-F+2", @"1", @"F-[[-F-F+F+FF2]+FF2]+F[+F+F+FF2]-FF+F-F2", @"2", nil];
    
    
    NSDictionary *rules = [NSDictionary dictionaryWithObjectsAndKeys:
                           straight, @"Straight", 
                           bend, @"Bend",
                           branches, @"Branches",
                           moreBranches, @"More Branches",
                           elaborate, @"Elaborate",
                           gnarled, @"Gnarled",
                           crooked, @"Crooked",
                           nil];

    return rules;
}

-(void) showMenu {
    if (!menu) {
        self.menu = [CCMenu menuWithItems:nil];
        
        NSDictionary *sysRules = [self systemRules];
        
        for (NSString *ruleKey in sysRules.allKeys) {
            CCMenuItemFont *item = [CCMenuItemFont itemFromString:ruleKey block:^(id sender) {
                NSDictionary *rules = [sysRules objectForKey:ruleKey];
                menu.visible = NO;
                [self showLSystemWithRules:rules];
            }];
            [menu addChild:item];
        }
        
        [menu alignItemsVertically];
        
        [self addChild:menu z:2];        
    }
    
    menu.visible = YES;
}

-(void) showLSystemWithRules:(NSDictionary*)rules {
    // remove current lsystem
    [lsystem removeFromParentAndCleanup:YES];
    
    self.lsystem = [LSystemNode lsystemWithRules:rules];
    [self addChild:lsystem];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [self showMenu];
    
    return YES;
}

@end
