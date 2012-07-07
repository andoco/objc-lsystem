//
//  LSystemNode.m
//  LSystem-Cocos2d
//
//  Created by Andrew O'Connor on 07/07/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LSystemNode.h"

#import "LSystem.h"
#import "RenderTextureSegmentDrawer.h"

@interface LSystemNode () {
    CGPoint pos;
    CGFloat duration;
    CGFloat time;
}

@property (nonatomic, retain) LSystem *lsys;

@end

@implementation LSystemNode

@synthesize generation;

@synthesize lsys;

+(id) lsystemWithRules:(NSDictionary*)rules {
    return [[[LSystemNode alloc] initWithRules:rules] autorelease];
}

-(id) initWithRules:(NSDictionary*)rules {
    if ((self = [super init])) {
        // find center bottom of screen
        CGSize size = [[CCDirector sharedDirector] winSize];
        CGPoint centre = ccpMult(ccpFromSize(size), 0.5);
        pos = ccp(centre.x, 0);

        // render segments to a CCRenderTexture
        RenderTextureSegmentDrawer *segDrawer = [RenderTextureSegmentDrawer node];
        [self addChild:segDrawer];
        
        // create LSystem
        self.lsys = [[[LSystem alloc] init] autorelease];
        lsys.segment = segDrawer;
        lsys.rules = rules;
        
        generation = 6;
        
        // find duration required for drawing l-system
        duration = [lsys duration:generation];
        time = 0;
        
        [self scheduleUpdate];
    }
    return self;
}

-(void) dealloc {
    [lsys release];
    [super dealloc];
}

-(void) update:(ccTime)dt {
    // animate drawing of l-system
    if (time < duration) {
        time += dt;
        
        [lsys.segment clear];
        
        [lsys draw:pos generation:generation time:time ease:-1];        
    }
}

@end
