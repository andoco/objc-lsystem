#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LSystemNode : CCNode {
    
}

@property (nonatomic, assign) NSInteger generation;
@property (nonatomic, assign) CGFloat segmentLength;
@property (nonatomic, assign) CGFloat angle;

/** Drawing origin relative to the lsystem size. Defaults to the centre of the size. */
@property (nonatomic, assign) CGPoint drawOrigin;

/** Color used to clear the drawing canvas. Defaults to transparent. */
@property (nonatomic, assign) ccColor4F clearColor;

+(id) nodeWithSize:(CGSize)size;
-(id) initWithSize:(CGSize)size;
-(void) startWithRules:(NSDictionary*)rules animate:(BOOL)animate;

@end
