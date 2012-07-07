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

@end

// LSystemLayer implementation
@implementation LSystemLayer

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
        
        LSystemNode *lsys = [LSystemNode lsystemWithRules:moreBranches];
        [self addChild:lsys];        
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[super dealloc];
}
@end
