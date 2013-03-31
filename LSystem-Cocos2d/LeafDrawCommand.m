#import "LeafDrawCommand.h"

#import "DrawContext.h"

@implementation LeafDrawCommand

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void) drawCircles:(CCDrawNode*)dn point:(CGPoint)p radius:(CGFloat)baseR numCircles:(NSInteger)numCircles {
    for (int i=0; i < numCircles; i++) {
        float r = baseR - (baseR * 0.7 * i / numCircles);
        float g = 100 + (155 * i / numCircles);
        ccColor4F c = ccc4f(50/255, g/255, 50/255, 100);
        [dn drawDot:p radius:r color:c];        
    }
}

-(void) runCommandForSystem:(LSystem*)system generation:(NSInteger)generation rule:(NSString*)rule angle:(CGFloat)angle length:(CGFloat)length time:(CGFloat)time {
    
    DrawContext *ctx = system.ctx;
    CCDrawNode *dn = [CCDrawNode node];
    
    CGPoint p = ctx.currentState.translation;
    
    [self.rt begin];
    
    const int numCircles = 3;
    const float baseR = length;
    
    [self drawCircles:dn point:p radius:baseR numCircles:numCircles];
    
    for (int i=0; i < numCircles; i++) {
        float r2 = baseR / 3;
        CGPoint p2 = ccpAdd(p, ccp(baseR - r2, 0));
        CGFloat a = (generation * M_PI_4) + M_PI * 2 / (i+1);
        p2 = ccpRotateByAngle(p2, p, a);
        [self drawCircles:dn point:p2 radius:r2 numCircles:numCircles];
    }
    
    [dn draw];
    
    [self.rt end];
}

@end
