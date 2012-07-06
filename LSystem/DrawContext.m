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
@property (nonatomic, retain) CCRenderTexture *rt;
@end

@implementation DrawContext

@synthesize states;
@synthesize currentState;
@synthesize rt;

-(id) init {
    if ((self = [super init])) {
        self.states = [NSMutableArray arrayWithObject:[DrawState state]];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        self.rt = [CCRenderTexture renderTextureWithWidth:winSize.width height:winSize.height];
        rt.position = ccpMult(ccpFromSize(self.contentSize), 0.5);
        [self addChild:rt];
    }
    return self;
}

-(void) dealloc {
    [states release];
    [rt release];
    [super dealloc];
}

-(DrawState*) currentState {
    return [states lastObject];
}

-(void) translate:(CGPoint)delta {
//    CCLOG(@"Before: %@", self.currentState);
    DrawState *oldState = [DrawState stateWithState:self.currentState];
    // the delta needs to rotated first so that it is relative to the current heading
    //delta = ccpRotateByAngle(delta, ccp(0,0), CC_DEGREES_TO_RADIANS(self.currentState.rotation));
    
    // apply the delta to the current translation
    self.currentState.translation = ccpAdd(self.currentState.translation, delta);
    
//    CCLOG(@"Translation from %@ to %@", oldState, self.currentState);
}

-(void) rotate:(CGFloat)angle {
    //CCLOG(@"Before: %@", self.currentState);
    DrawState *oldState = [DrawState stateWithState:self.currentState];
    self.currentState.rotation += angle;
    //self.currentState.translation = ccpRotateByAngle(self.currentState.translation, self.currentState.translation, CC_DEGREES_TO_RADIANS(angle));
//    CCLOG(@"Rotation from %@ to %@", oldState, self.currentState);
}

-(void) scale:(CGFloat)scale {
//    CCLOG(@"Before: %@", self.currentState);
    DrawState *oldState = [DrawState stateWithState:self.currentState];
    self.currentState.scale += scale;
//    CCLOG(@"Scale from %@ to %@", oldState, self.currentState);
}

-(void) push {
    [states addObject:[DrawState stateWithState:self.currentState]];
//    CCLOG(@"State pushed (numStates = %d)", [states count]);
}

-(void) pop {
    [states removeLastObject];
//    CCLOG(@"State popped (numStates = %d)", [states count]);
}

-(void) lineColor:(ccColor3B)color {
    DrawState *oldState = [DrawState stateWithState:self.currentState];
    self.currentState.lineColor = color;
//    CCLOG(@"Line color from {%d,%d,%d} to {%d,%d,%d}", oldState.lineColor.r, oldState.lineColor.g, oldState.lineColor.b, self.currentState.lineColor.r, self.currentState.lineColor.g, self.currentState.lineColor.b);
}

-(void) segmentSize:(CGFloat)size {
    DrawState *oldState = [DrawState stateWithState:self.currentState];
    self.currentState.segmentSize = size;
//    CCLOG(@"Segment size from %f to %f", oldState.segmentSize, size);
}

//-(void) rect:(CGRect)rect {  
//    
//    CCLOG(@"Rect: %@", NSStringFromCGRect(rect));
//    
//    DrawState *state = [DrawState state];
//    for (DrawState *s in states) {
//        state.translation = ccpAdd(state.translation, s.translation);
//        state.rotation += s.rotation;
//        //state.translation = ccpRotateByAngle(state.translation, state.translation, CC_DEGREES_TO_RADIANS(s.rotation));
//        state.scale += s.scale;
//    }
//    
//    CCLOG(@"Using aggregate state %@", state);
//    
//    CGPoint absP = ccpAdd(state.translation, rect.origin);
//    absP = ccpRotateByAngle(absP, state.translation, CC_DEGREES_TO_RADIANS(state.rotation));
//
//    [rt begin];    
//    
////    glColor4ub(0, 0, 255, 255);
////    glPointSize(500);
////    ccDrawPoint(ccp(50,50));
//    
//    glPushMatrix();    
//    
////    glTranslatef(state.translation.x, state.translation.y, 0);
////    glRotatef(state.rotation, 0, 0, 1);
//    
//    glPointSize(rect.size.width);
//    ccDrawPoint(absP);
//    
//    glPopMatrix();
//    [rt end];
//}

//-(void) line:(CGPoint)p1 to:(CGPoint)p2 {
//    CCLOG(@"line from %@ to %@", NSStringFromCGPoint(p1), NSStringFromCGPoint(p2));
//    
//    DrawState *state = [DrawState state];
//    for (DrawState *s in states) {
//        CCLOG(@"%@", s);
//        state.translation = ccpAdd(state.translation, s.translation);
//        state.rotation += s.rotation;
//        state.scale += s.scale;
//    }
//    
//    CCLOG(@"Using aggregate state %@", state);
//    
//    CGPoint absP1 = ccpAdd(state.translation, p1);
//    CGPoint absP2 = ccpAdd(state.translation, p2);
//    
//    absP1 = ccpRotateByAngle(absP1, state.translation, CC_DEGREES_TO_RADIANS(state.rotation));
//    absP2 = ccpRotateByAngle(absP2, state.translation, CC_DEGREES_TO_RADIANS(state.rotation));
//    
////    CGPoint absP1 = ccpRotateByAngle(p1, state.translation, CC_DEGREES_TO_RADIANS(state.rotation));
////    CGPoint absP2 = ccpRotateByAngle(p2, state.translation, CC_DEGREES_TO_RADIANS(state.rotation));
////    
////    absP1 = ccpAdd(state.translation, absP1);
////    absP2 = ccpAdd(state.translation, absP2);
//
//    
//    //DrawState *state = self.currentState;
//    
////    CGPoint pp1 = ccpRotateByAngle(ccpAdd(state.translation, p1), state.translation, state.rotation);
////    CGPoint pp2 = ccpRotateByAngle(ccpAdd(state.translation, p2), state.translation, state.rotation);
//    
//    [rt begin];
//    glPushMatrix();
//    
////    glTranslatef(state.translation.x, state.translation.y, 0);
////    glRotatef(state.rotation, 0, 0, 1);
//    
////    ccDrawLine(ccpAdd(state.translation, pp1), ccpAdd(state.translation, pp2));
//    ccDrawLine(absP1, absP2);
//    glPopMatrix();
//    [rt end];
//}

-(void) forward:(CGFloat)length {
    DrawState *state = self.currentState;
    
    CGPoint p1 = state.translation;
    
    float radRotation = CC_DEGREES_TO_RADIANS(state.rotation);
	float x = sin(radRotation) * length;
	float y = cos(radRotation) * length;
    CGPoint delta = ccp(x,y);
    
    CGPoint p2 = ccpAdd(p1, delta);
    
    CGPoint markerPos = ccpAdd(p1, ccpMult(delta, 0.25));
    
    [rt begin];
    
    ccColor3B c = state.lineColor;
    glColor4f(c.r / 255.0, c.g / 255.0, c.b / 255.0, 1);
    glLineWidth(state.segmentSize);
    
    // draw segment line
    ccDrawLine(p1, p2);
    
//    glPushMatrix();
//    glPointSize(10);
//    glRotatef(radRotation, 0, 0, 1);
    
    // draw marker on segment line
    ccDrawCircle(markerPos, length*0.25, CC_DEGREES_TO_RADIANS(0), 16, NO);
    
//    glPopMatrix();
    [rt end];
    
    // must update the current translation
    state.translation = p2;
}

@end
