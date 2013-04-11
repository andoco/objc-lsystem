#import <Foundation/Foundation.h>

@interface GraphPoint : NSObject

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) NSUInteger depth;

+(id) graphPointWithPoint:(CGPoint)point depth:(NSUInteger)depth;

@end
