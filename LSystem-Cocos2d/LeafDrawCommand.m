//
//  LeafDrawCommand.m
//  LSystem-Cocos2d
//
//  Created by Andrew O'Connor on 31/03/2013.
//
//

#import "LeafDrawCommand.h"

#import "DrawContext.h"

@implementation LeafDrawCommand {
    CCSprite *blob_;
}

- (id)init
{
    self = [super init];
    if (self) {
        blob_ = [[CCSprite spriteWithFile:@"blob.png"] retain];
        blob_.blendFunc = (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE };
        blob_.anchorPoint = ccp(0.5, 0.25);
    }
    return self;
}

-(void) runCommandForSystem:(LSystem*)system generation:(NSInteger)generation rule:(NSString*)rule angle:(CGFloat)angle length:(CGFloat)length time:(CGFloat)time {
    
    DrawContext *ctx = system.ctx;
    
    CGPoint p = ctx.currentState.translation;
    
    [self.rt begin];
    
    blob_.position = p;
    
    blob_.scale = 2;
    blob_.opacity = 200;
    blob_.color = ccc3(200, 50, 50);
    blob_.scaleX = blob_.scale * 0.75;
    blob_.rotation = ctx.currentState.rotation;
    
    [blob_ visit];
    
    blob_.scale = 1;
    blob_.opacity = 250;
    blob_.color = ccc3(255, 50, 50);
    blob_.scaleX = blob_.scale * 0.75;
    blob_.rotation = ctx.currentState.rotation;
    
    [blob_ visit];
        
    [self.rt end];
}

@end
