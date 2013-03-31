//
//  RenderTextureSegmentDrawer.m
//  LSystem
//
//  Created by Andrew O'Connor on 06/07/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RenderTextureSegmentDrawer.h"

@implementation RenderTextureSegmentDrawer

-(id) init {
    if ((self = [super init])) {
//        CGSize winSize = [[CCDirector sharedDirector] winSize];
//        self.rt = [CCRenderTexture renderTextureWithWidth:winSize.width height:winSize.height];
//        rt.position = ccpMult(ccpFromSize(winSize), 0.5);
//        [self addChild:rt];
    }
    return self;
}

-(void) dealloc {
    [_rt release];
    [super dealloc];
}

-(void) clear {
    [_rt clear:0 g:0 b:0 a:255];
}

-(void) segmentFrom:(CGPoint)from to:(CGPoint)to generation:(NSInteger)generation time:(NSInteger)time identifier:(NSInteger)identifier {
    [_rt begin];
    
    glColor4f(0, 1.0 / (generation + 1), 0, 1);    
    glLineWidth(1 + generation * 2);
    ccDrawLine(from, to);
    
    glColor4f(1, 1, 1, 1);
    glPointSize(2 * CC_CONTENT_SCALE_FACTOR());
    ccDrawPoint(to);
    
//    if (generation == 0) {
//        glPointSize(25 * CC_CONTENT_SCALE_FACTOR());
//        glColor4f(0.5, 0.5, 1, 0.25);
//        ccDrawPoint(to);
//    }
    
    [_rt end];
}

@end
