#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "LSystem.h"

@interface RenderTextureSegmentDrawer : NSObject <SegmentDrawer> {
    
}

@property (nonatomic, strong) CCRenderTexture *rt;
@property (nonatomic, assign) CGFloat baseWidth;
@property (nonatomic, assign) CGFloat widthScaleFactor;

@end
