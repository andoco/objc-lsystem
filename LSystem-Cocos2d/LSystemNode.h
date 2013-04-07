#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "LSystem.h"

@interface LSystemNode : CCNode <SegmentDrawer>

@property (nonatomic, assign) NSInteger generation;
@property (nonatomic, assign) CGFloat segmentLength;
@property (nonatomic, assign) CGFloat angle;

/** Drawing origin relative to the lsystem size. Defaults to the centre of the size. */
@property (nonatomic, assign) CGPoint drawOrigin;

/** Color used to clear the drawing canvas. Defaults to transparent. */
@property (nonatomic, assign) ccColor4F clearColor;

#pragma mark Segments
@property (nonatomic, assign) CGFloat baseWidth;
@property (nonatomic, assign) CGFloat widthScaleFactor;
@property (nonatomic, assign) CGFloat leavesPerSegment;
@property (nonatomic, assign) ccColor4B leafColor;
@property (nonatomic, assign) CGFloat maxLeafSize;

+(id) nodeWithSize:(CGSize)size;
-(id) initWithSize:(CGSize)size;
-(void) startWithRules:(NSDictionary*)rules animate:(BOOL)animate;
-(UIImage*) image;

@end
