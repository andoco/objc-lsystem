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


@implementation LSystemNode {
    CGPoint pos_;
    CGFloat duration_;
    CGFloat time_;
    LSystem *lsys_;
    CCRenderTexture *rt_;
}

+(id) lsystemWithRules:(NSDictionary*)rules {
    return [[LSystemNode alloc] initWithRules:rules];
}

-(id) initWithRules:(NSDictionary*)rules {
    if ((self = [super init])) {
        CCLOG(@"Drawing with rules %@", rules);
        
        // find center bottom of screen
        CGSize size = [[CCDirector sharedDirector] winSize];
        CGPoint centre = ccpMult(ccpFromSize(size), 0.5);
        pos_ = ccp(centre.x, 0);
        
        rt_ = [CCRenderTexture renderTextureWithWidth:size.width height:size.height];
        rt_.position = centre;
        [self addChild:rt_];

        // render segments to a CCRenderTexture
        RenderTextureSegmentDrawer *segDrawer = [[RenderTextureSegmentDrawer alloc] init];
        segDrawer.rt = rt_;
        
        // create LSystem
        lsys_ = [[LSystem alloc] init];
        lsys_.segment = segDrawer;
        lsys_.rules = rules;
        lsys_.segmentLength = size.height / 10;
        lsys_.cost = 0.1;
        
        LeafDrawCommand *leafCommand = [[LeafDrawCommand alloc] init];
        leafCommand.rt = rt_;
        lsys_.commands = [NSDictionary dictionaryWithObjectsAndKeys:leafCommand, @"L", nil];
        
        self.generation = 6;
        
        // find duration required for drawing l-system
        duration_ = [lsys_ duration:self.generation];
        CCLOG(@"Drawing with duration %f", duration_);
        time_ = 0;
        
        [self scheduleUpdate];
    }
    return self;
}


-(void) update:(ccTime)dt {
    // animate drawing of l-system
    if (time_ < duration_) {
        time_ += dt;
        
        [rt_ clear:0 g:0 b:0 a:1];
        
        [lsys_ draw:pos_ generation:self.generation time:time_ ease:-1];
    }
}

@end
