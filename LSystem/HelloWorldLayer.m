//
//  HelloWorldLayer.m
//  LSystem
//
//  Created by Andrew O'Connor on 07/04/2012.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

#import "DrawContext.h"
#import "LSystem.h"
#import "DrawState.h"
#import "RenderTextureSegmentDrawer.h"

@interface HelloWorldLayer () {
    CGFloat duration;
    CGFloat time;
}
@property (nonatomic, retain) LSystem *lsys;
@end

// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize lsys;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
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
        
        CGPoint centre = ccpMult(ccpFromSize(self.contentSize), 0.5);
        
        RenderTextureSegmentDrawer *segDrawer = [RenderTextureSegmentDrawer node];
        [self addChild:segDrawer];
        
        self.lsys = [[[LSystem alloc] init] autorelease];
        lsys.segment = segDrawer;
        lsys.rules = moreBranches;
        lsys.segmentLength = 30;
//        lsys.cost = 0.1;
        
        NSInteger generations = 6;
        
        duration = [lsys duration:generations];
        time = 0;
        
        CCLOG(@"lsystem duration = %f", duration);
                
        [self scheduleUpdate];
	}
	return self;
}

-(void) update:(ccTime)dt {
    if (time < duration) {
        time += dt;
        
        CGPoint centre = ccpMult(ccpFromSize(self.contentSize), 0.5);
        
        CGPoint pos = ccp(centre.x, 0);
        
        [lsys draw:pos generation:6 time:time ease:-1];        
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [lsys release];
	[super dealloc];
}
@end
