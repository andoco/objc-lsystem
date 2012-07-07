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

+(id) state {
    DrawState *newState = [[[DrawState alloc] init] autorelease];
    
    return newState;
}

+(id) stateWithState:(DrawState*)state {
    DrawState *newState = [[[DrawState alloc] init] autorelease];
    newState.translation = state.translation;
    newState.rotation = state.rotation;
    newState.scale = state.scale;
    
    return newState;
}

-(id) init {
    if ((self = [super init])) {
        self.translation = CGPointMake(0, 0);
        self.rotation = 0;
        self.scale = 1;
    }
    return self;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<DrawState translation=%@ rotation=%f scale=%f >", NSStringFromCGPoint(translation), rotation, scale];
}

@end