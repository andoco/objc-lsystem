//
//  LSystemNode.m
//  LSystem-Cocos2d
//
//  Created by Andrew O'Connor on 07/07/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LSystemNode.h"

#import "LeafDrawCommand.h"
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
        CCLOG(@"Drawing with rules %@", rules);
        
        // find center bottom of screen
        CGSize size = [[CCDirector sharedDirector] winSize];
        CGPoint centre = ccpMult(ccpFromSize(size), 0.5);
        pos = ccp(centre.x, 0);
        
        CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:size.width height:size.height];
        rt.position = centre;
        [self addChild:rt];

        // render segments to a CCRenderTexture
        RenderTextureSegmentDrawer *segDrawer = [[RenderTextureSegmentDrawer alloc] init];
        segDrawer.rt = rt;
        
        // create LSystem
        self.lsys = [[[LSystem alloc] init] autorelease];
        lsys.segment = segDrawer;
        lsys.rules = rules;
        lsys.segmentLength = 30;
        lsys.cost = 0.1;
        
        LeafDrawCommand *leafCommand = [[LeafDrawCommand alloc] init];
        leafCommand.rt = rt;
        lsys.commands = [NSDictionary dictionaryWithObjectsAndKeys:leafCommand, @"L", nil];
        
        self.generation = 6;
        
        // find duration required for drawing l-system
        duration = [lsys duration:generation];
        CCLOG(@"Drawing with duration %f", duration);
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
