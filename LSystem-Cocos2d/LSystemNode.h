#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LSystemNode : CCNode {
    
}

@property (nonatomic, assign) NSInteger generation;

+(id) lsystemWithRules:(NSDictionary*)rules;
-(id) initWithRules:(NSDictionary*)rules;
-(void) start;

@end
