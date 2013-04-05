#import "RenderTextureSegmentDrawer.h"

@implementation RenderTextureSegmentDrawer {
    NSMutableDictionary *lastSizes_;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.baseWidth = 1;
        self.widthScaleFactor = 1.2;
    }
    return self;
}

-(CGFloat) widthForGeneration:(NSInteger)generation {
    return self.baseWidth + (self.baseWidth * generation * self.widthScaleFactor);
}

-(void) segmentFrom:(CGPoint)from to:(CGPoint)to generation:(NSInteger)generation time:(CGFloat)time identifier:(NSInteger)identifier {
    [_rt begin];
    
    ccGLBlendFunc(GL_ONE,GL_ZERO);
    
    CGFloat generationWidth = [self widthForGeneration:generation];
    CGFloat width = generationWidth;
    
//    CCLOG(@"id=%d, generation=%d, time=%f, width=%f", identifier, generation, time, width);
    
    ccColor4F c = ccc4f(0, 0.2 + (1.0 / (generation + 1) * 0.8), 0, 1);
    
    ccDrawColor4F(c.r, c.g, c.b, c.a);
    glLineWidth(width * CC_CONTENT_SCALE_FACTOR());
    ccDrawLine(from, to);
    
    ccDrawColor4F(1, 1, 1, 1);
    ccPointSize(2 * CC_CONTENT_SCALE_FACTOR());
    ccDrawPoint(to);
    
    [_rt end];
}

@end
