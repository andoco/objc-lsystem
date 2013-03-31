//
//  RenderTextureSegmentDrawer.m
//  LSystem
//
//  Created by Andrew O'Connor on 06/07/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RenderTextureSegmentDrawer.h"

@implementation RenderTextureSegmentDrawer

-(void) dealloc {
    [_rt release];
    [super dealloc];
}

-(void) clear {
    [_rt clear:0 g:0 b:0 a:255];
}

-(void) segmentFrom:(CGPoint)from to:(CGPoint)to generation:(NSInteger)generation time:(NSInteger)time identifier:(NSInteger)identifier {
    [_rt begin];
    
    ccDrawColor4F(0, 1.0 / (generation + 1), 0, 1);
    glLineWidth((1 + generation * 2) * CC_CONTENT_SCALE_FACTOR());
    ccDrawLine(from, to);
    
    ccDrawColor4F(1, 1, 1, 1);
    ccPointSize(2 * CC_CONTENT_SCALE_FACTOR());
    ccDrawPoint(to);
    
    CC_INCREMENT_GL_DRAWS(1);
    
    [_rt end];
}

@end
