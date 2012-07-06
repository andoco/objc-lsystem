//
//  DrawState.m
//  LSystem
//
//  Created by Andrew O'Connor on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawState.h"

@implementation DrawState

@synthesize translation;
@synthesize rotation;
@synthesize scale;
@synthesize lineColor;
@synthesize segmentSize;

+(id) state {
    DrawState *newState = [[[DrawState alloc] init] autorelease];
    
    return newState;
}

+(id) stateWithState:(DrawState*)state {
    DrawState *newState = [[[DrawState alloc] init] autorelease];
    newState.translation = state.translation;
    newState.rotation = state.rotation;
    newState.scale = state.scale;
    newState.lineColor = state.lineColor;
    newState.segmentSize = state.segmentSize;
    
    return newState;
}

-(id) init {
    if ((self = [super init])) {
        self.translation = ccp(0,0);
        self.rotation = 0;
        self.scale = 1;
        self.lineColor = ccc3(255, 255, 255);
        self.segmentSize = 1;
    }
    return self;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<DrawState translation=%@ rotation=%f scale=%f lineColor=%d,%d,%d segmentSize=%f >", NSStringFromCGPoint(translation), rotation, scale, lineColor.r, lineColor.g, lineColor.b, segmentSize];
}

@end