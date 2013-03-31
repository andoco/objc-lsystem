//
//  RenderTextureSegmentDrawer.m
//  LSystem
//
//  Created by Andrew O'Connor on 06/07/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RenderTextureSegmentDrawer.h"

@implementation RenderTextureSegmentDrawer

- (id)init
{
    self = [super init];
    if (self) {
        self.baseWidth = 1;
        self.widthScaleFactor = 2;
    }
    return self;
}

-(void) segmentFrom:(CGPoint)from to:(CGPoint)to generation:(NSInteger)generation time:(NSInteger)time identifier:(NSInteger)identifier {
    [_rt begin];
    
    float width = self.baseWidth + (self.baseWidth * generation * self.widthScaleFactor);
//    CCLOG(@"generation %d = %f wide", generation, width);
    
    ccDrawColor4F(0, 0.2 + (1.0 / (generation + 1) * 0.8), 0, 1);
    glLineWidth(width * CC_CONTENT_SCALE_FACTOR());
    ccDrawLine(from, to);
    
    ccDrawColor4F(1, 1, 1, 1);
    ccPointSize(2 * CC_CONTENT_SCALE_FACTOR());
    ccDrawPoint(to);
    
    [_rt end];
}

@end
