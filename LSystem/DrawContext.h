//
//  DrawContext.h
//  LSystem
//
//  Created by Andrew O'Connor on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class DrawState;

@interface DrawContext : CCNode

@property (nonatomic, readonly) DrawState *currentState;

-(void) translate:(CGPoint)delta;
-(void) rotate:(CGFloat)angle;
-(void) scale:(CGFloat)scale;
-(void) push;
-(void) pop;
-(void) lineColor:(ccColor3B)color;
-(void) segmentSize:(CGFloat)size;

/** Draw forward */
-(void) forward:(CGFloat)length;

@end
