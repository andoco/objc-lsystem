#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "LSystem.h"

@interface LeafDrawCommand : NSObject <LSysCommand>

@property (nonatomic, strong) CCRenderTexture *rt;

@end
