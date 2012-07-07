//
//  LSystem.h
//  LSystem
//
//  Created by Andrew O'Connor on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DrawContext;

@protocol SegmentDrawer <NSObject>

-(void) clear;
-(void) segmentFrom:(CGPoint)from to:(CGPoint)to generation:(NSInteger)generation time:(NSInteger)time identifier:(NSInteger)identifier;

@end

@interface LSystem : NSObject {
    NSInteger _segments;
    CGFloat _duration;
    BOOL _timed;
}

@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat segmentLength;
@property (nonatomic, assign) CGFloat threshold;
@property (nonatomic, retain) NSDictionary *rules;
@property (nonatomic, assign) CGFloat decrease;
@property (nonatomic, assign) CGFloat cost;
@property (nonatomic, retain) NSString *root;
@property (nonatomic, retain) DrawContext *ctx;
@property (nonatomic, retain) id<SegmentDrawer> segment;

-(void) reset;
-(void) growGeneration:(NSInteger)generation withRule:(NSString*)rule angle:(CGFloat)aAngle length:(CGFloat)length time:(CGFloat)time draw:(BOOL)draw;

/** Returns the total draw time needed based on the current cost.
 
 In an animation, the system will expand as time progresses.
 Each F command that draws a segment has a cost that depletes time.
 To calculate the total amount of time for a number of generations,
 we need to recurse through the system.
 Time does not flow through the system linearly, 
 it "branches" from generation to generation.
 
 */
-(CGFloat) duration:(NSInteger)generation;

-(void) draw:(CGPoint)pos generation:(NSInteger)generation;
-(void) draw:(CGPoint)pos generation:(NSInteger)generation time:(CGFloat)time ease:(CGFloat)ease;

@end
