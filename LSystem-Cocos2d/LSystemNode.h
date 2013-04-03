#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LSystemNode : CCNode {
    
}

@property (nonatomic, assign) NSInteger generation;
@property (nonatomic, assign) CGFloat segmentLength;
@property (nonatomic, assign) CGFloat angle;

-(void) startWithRules:(NSDictionary*)rules;

@end
