#import "DrawContext.h"

@implementation DrawContext {
    NSMutableArray *states_;
}

-(id) init {
    if ((self = [super init])) {
        states_ = [NSMutableArray arrayWithObject:[DrawState state]];
    }
    return self;
}


-(DrawState*) currentState {
    return [states_ lastObject];
}

-(void) translate:(CGPoint)delta {    
    DrawState *state = self.currentState;
    
    CGFloat rot = -state.rotation * M_PI / 180;
    
    delta = CGPointApplyAffineTransform(delta, CGAffineTransformMakeRotation(rot));
    
    state.translation = CGPointMake(state.translation.x + delta.x, state.translation.y + delta.y);    
}

-(void) rotate:(CGFloat)angle {
    self.currentState.rotation += angle;
}

-(void) scale:(CGFloat)scale {
    self.currentState.scale += scale;
}

-(void) push {
    [states_ addObject:[DrawState stateWithState:self.currentState]];
}

-(void) pop {
    [states_ removeLastObject];
}

@end
