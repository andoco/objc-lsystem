#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "DrawState.h"

/**
 Coordinate system uses degrees for rotation with 0 degrees point vertically up on the y-axis.
 Positive rotation moves clockwise around the current translation.
 */
@interface DrawContext : NSObject

@property (nonatomic, readonly) DrawState *currentState;

-(void) translate:(CGPoint)delta;
-(void) rotate:(CGFloat)angle;
-(void) scale:(CGFloat)scale;
-(void) push;
-(void) pop;

@end
