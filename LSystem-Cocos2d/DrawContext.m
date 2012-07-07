//
//  DrawContext.m
//  LSystem
//
//  Created by Andrew O'Connor on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawContext.h"

#import "DrawState.h"

@interface DrawContext ()
@property (nonatomic, retain) NSMutableArray *states;
@end

@implementation DrawContext

@synthesize states;
@synthesize currentState;

-(id) init {
    if ((self = [super init])) {
        self.states = [NSMutableArray arrayWithObject:[DrawState state]];        
    }
    return self;
}

-(void) dealloc {
    [states release];
    [super dealloc];
}

-(DrawState*) currentState {
    return [states lastObject];
}

-(void) translate:(CGPoint)delta {    
    DrawState *state = self.currentState;
    
    delta = ccpRotateByAngle(delta, ccp(0,0), CC_DEGREES_TO_RADIANS(-state.rotation));
    
    state.translation = ccpAdd(state.translation, delta);    
}

-(void) rotate:(CGFloat)angle {
    self.currentState.rotation += angle;
}

-(void) scale:(CGFloat)scale {
    self.currentState.scale += scale;
}

-(void) push {
    [states addObject:[DrawState stateWithState:self.currentState]];
}

-(void) pop {
    [states removeLastObject];
}

@end
