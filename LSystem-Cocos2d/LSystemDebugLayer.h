#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LSystemDebugLayer : CCLayer {
    
}

+(id) sharedDebugLayer;
-(void) clear;
-(void) addSegmentLabelForPoint:(CGPoint)point generation:(NSInteger)generation depth:(NSUInteger)depth identifier:(NSInteger)identifier;

@end
