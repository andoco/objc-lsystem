#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "LSystem.h"

static const ccColor4B LSystemLeafColorSummer = {100, 175, 100, 255}; // green
static const ccColor4B LSystemLeafColorSpring = {200, 150, 150, 255}; // pink
static const ccColor4B LSystemLeafColorAutumn = {150, 130, 100, 255};

typedef enum {
    LSystemNodeLeafDrawModePoints,
    LSystemNodeLeafDrawModeTriangles
} LSystemLeafDrawMode;

@interface LSystemNode : CCNode <SegmentDrawer>

@property (nonatomic, assign) NSInteger generation;
@property (nonatomic, assign) CGFloat segmentLength;
@property (nonatomic, assign) CGFloat angle;

/** Drawing origin relative to the lsystem size. Defaults to the centre of the size. */
@property (nonatomic, assign) CGPoint drawOrigin;

/** Color used to clear the drawing canvas. Defaults to transparent. */
@property (nonatomic, assign) ccColor4F clearColor;

@property (nonatomic, assign) CGFloat minSegmentSize;

/** The lower the generationSizeFactor the greater the change in size between generations */
@property (nonatomic, assign) CGFloat generationSizeFactor;
/** The lower the depthSizeFactor the smaller the affect of depth on the change in size in a generation */
@property (nonatomic, assign) CGFloat depthSizeFactor;

#pragma mark Leaves
@property (nonatomic, assign) LSystemLeafDrawMode drawMode;
@property (nonatomic, assign) CGFloat leavesPerSegment;
@property (nonatomic, assign) ccColor4B leafColor;
@property (nonatomic, assign) CGFloat maxLeafSize;

+(id) nodeWithSize:(CGSize)size;
-(id) initWithSize:(CGSize)size;
-(void) startWithRules:(NSDictionary*)rules animate:(BOOL)animate;
-(UIImage*) image;

@end
