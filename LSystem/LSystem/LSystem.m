//
//  LSystem.m
//  LSystem
//
//  Created by Andrew O"Connor on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LSystem.h"

#import "DrawContext.h"
#import "DrawState.h"

#define LSYS_DURATION_MAX 100000.f

@implementation LSystem

@synthesize angle;
@synthesize segmentLength;
@synthesize threshold;
@synthesize rules;
@synthesize decrease;
@synthesize cost;
@synthesize root;
@synthesize ctx;
@synthesize segment;

-(id) init {
    if ((self = [super init])) {
        self.angle = 20;
        self.segmentLength = 40;
        self.decrease = 0.7;
        self.threshold = 3.0;
        self.cost = 0.25;
        self.root = @"1";
        
        self.rules = [NSDictionary dictionaryWithObjectsAndKeys:@"FF-1", @"1", nil];
        
        self.ctx = [[[DrawContext alloc] init] autorelease];
    }
    return self;
}

-(void) dealloc {
    [rules release];
    [ctx release];
    [segment release];
    [super dealloc];
}

-(void) reset {
    _segments = 0;
    _duration = 0;
}
    
-(void) growGeneration:(NSInteger)generation withRule:(NSString*)rule angle:(CGFloat)aAngle length:(CGFloat)length time:(CGFloat)time draw:(BOOL)draw {
    
    if (generation == 0)
        _duration = 1 + (LSYS_DURATION_MAX - time);
    
    if (length <= threshold) {
        _duration = 1 + (LSYS_DURATION_MAX - time);
        return;
    }

    // Custom command symbols:
    // If the rule is a key in the LSsytem.commands dictionary,
    // execute its value which is a function taking 6 parameters:
    // lsystem, generation, rule, angle, length and time.
    id<LSysCommand> cmd = [self.commands objectForKey:rule];
    if (cmd) {
        [cmd runCommandForSystem:self generation:generation rule:rule angle:aAngle length:length time:time];
    }
    
    // draw
    if (draw) {
        // Standard command symbols:
        // f signifies a move,
        // + and - rotate either left or right, | rotates 180 degrees,
        // [ and ] are for push() and pop(), e.g. offshoot branches,
        // < and > decrease or increases the segment length,
        // ( and ) decrease or increases the rotation angle.
        if ([rule isEqualToString:@"f"])
            [ctx translate:CGPointMake(0.f, -MIN(length, length*time))];
        else if ([rule isEqualToString:@"-"])
            [ctx rotate:MIN(+aAngle, +aAngle*time)];
        else if ([rule isEqualToString:@"+"])
            [ctx rotate:MAX(-aAngle, -aAngle*time)];
        else if ([rule isEqualToString:@"|"])
            [ctx rotate:180];
        else if ([rule isEqualToString:@"["])
            [ctx push];
        else if ([rule isEqualToString:@"]"]) 
            [ctx pop];
    }
    
    NSString *cmdString = [self.rules objectForKey:rule];

    if (cmdString != nil && generation > 0 && time > 0) {
        // Recursion:
        // Occurs when there is enough "life" (i.e. generation or time).
        // Generation is decreased and segment length scaled down.
        // Also, F symbols in the rule have a cost that depletes time.
        
        for (int i=0; i < [cmdString length]; i++) {
            NSString *cmd  = [NSString stringWithFormat:@"%c", [cmdString characterAtIndex:i]];
        
            // Modification command symbols:
            if ([cmd isEqualToString:@"F"]) {
                time -= self.cost;
                
                // TODO: This fixes duration issue with "Straight" ruleset but breaks "Branches" ruleset
//                _duration = 1 + (LSYS_DURATION_MAX - time);
            } else if ([cmd isEqualToString:@"!"])
                aAngle = -aAngle;
            else if ([cmd isEqualToString:@"("]) 
                aAngle *= 1.1;
            else if ([cmd isEqualToString:@")"]) 
                aAngle *= 0.9;
            else if ([cmd isEqualToString:@"<"]) 
                length *= 0.9;
            else if ([cmd isEqualToString:@">"]) 
                length *= 1.1;
            
            [self growGeneration:generation-1 withRule:cmd angle:aAngle length:length*self.decrease time:time draw:draw];
        }
        
    } else if ([rule isEqualToString:@"F"] || ((cmdString != nil) && [cmdString isEqualToString:@""])) {
        
        // Draw segment:
        // If the rule is an F symbol or empty (e.g. in Penrose tiles).
        // Segment length grows to its full size as time progresses.
        _segments += 1;
        if (draw && time >= 0) {
            length = MIN(length, length*time);
            
            DrawState *state = ctx.currentState;
            CGPoint p1 = state.translation;
            
            [ctx translate:CGPointMake(0, length)];
            
            CGPoint p2 = state.translation;
                        
            if (_timed) {
                [segment segmentFrom:p1 to:p2 generation:generation time:time identifier:_segments];
            } else {
                [segment segmentFrom:p1 to:p2 generation:generation time:-1 identifier:_segments];
            }
        }
    }
}

//-(void) segment:(CGFloat)length generation:(NSInteger)generation time:(CGFloat)time identifier:(NSInteger)identifier {
//    [ctx lineColor:ccc3(255*CCRANDOM_0_1(), 255*CCRANDOM_0_1(), 255*CCRANDOM_0_1())];
//    [ctx segmentSize:generation * 2];
//    [ctx forward:length];    
//}

/** Returns the total draw time needed based on the current cost.
 
 In an animation, the system will expand as time progresses.
 Each F command that draws a segment has a cost that depletes time.
 To calculate the total amount of time for a number of generations,
 we need to recurse through the system.
 Time does not flow through the system linearly, 
 it "branches" from generation to generation.
 
 */
-(CGFloat) duration:(NSInteger)generation {
    [ctx push];
    [self reset];
    [self growGeneration:generation withRule:self.root angle:self.angle length:self.segmentLength time:LSYS_DURATION_MAX draw:NO];
    [ctx pop];
    
    return _duration;
}

-(void) draw:(CGPoint)pos generation:(NSInteger)generation {
    [self draw:pos generation:generation time:-1 ease:-1];
}

/* Draws a number of generations at the given position.
 
 The time parameter can be used to progress the system in an animatiom.
 As time nears LSystem.duration(generation), more segments will be drawn.
 
 The ease parameter can be used to gradually increase the branching angle
 as more segments are drawn.
 
 */
-(void) draw:(CGPoint)pos generation:(NSInteger)generation time:(CGFloat)time ease:(CGFloat)ease {    
    CGFloat angleToUse = self.angle;
    if (time != -1 && ease != -1)
        angleToUse = MIN(self.angle, self.angle * time / ease);
        
    _timed = YES;
    if (time == -1) {
        _timed = NO;
        time = LSYS_DURATION_MAX;
    }
    
    // clear existing drawing
//    [segment clear];
    
    [ctx push];
    [ctx translate:pos];
    [self reset];
    [self growGeneration:generation withRule:self.root angle:angleToUse length:self.segmentLength time:time draw:YES];
    [ctx pop];
}

@end
