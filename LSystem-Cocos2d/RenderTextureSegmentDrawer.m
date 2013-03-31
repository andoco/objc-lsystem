//
//  RenderTextureSegmentDrawer.m
//  LSystem
//
//  Created by Andrew O'Connor on 06/07/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RenderTextureSegmentDrawer.h"

@interface RenderTextureSegmentDrawer ()
@property (nonatomic, retain) CCRenderTexture *rt;
@end

@implementation RenderTextureSegmentDrawer

@synthesize rt;

-(id) init {
    if ((self = [super init])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.rt = [CCRenderTexture renderTextureWithWidth:winSize.width height:winSize.height];
        rt.position = ccpMult(ccpFromSize(winSize), 0.5);
        [self addChild:rt];
    }
    return self;
}

-(void) dealloc {
    [rt release];
    [super dealloc];
}

-(void) clear {
    [rt clear:0 g:0 b:0 a:255];
}

-(void) segmentFrom:(CGPoint)from to:(CGPoint)to generation:(NSInteger)generation time:(NSInteger)time identifier:(NSInteger)identifier {
    [rt begin];
    
    glColor4f(0, 1.0 / (generation + 1), 0, 1);    
    glLineWidth(1 + generation * 2);
    ccDrawLine(from, to);
    
    glColor4f(1, 1, 1, 1);
    glPointSize(2 * CC_CONTENT_SCALE_FACTOR());
    ccDrawPoint(to);
        
    [rt end];
}

@end
