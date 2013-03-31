#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DrawState : NSObject

@property (nonatomic, assign) CGPoint translation;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CGFloat scale;

+(id) state;
+(id) stateWithState:(DrawState*)state;

@end
