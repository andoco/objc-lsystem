#import "GraphPoint.h"

@implementation GraphPoint

+(id) graphPointWithPoint:(CGPoint)point depth:(NSUInteger)depth {
    GraphPoint *gp = [[self alloc] init];
    gp.point = point;
    gp.depth = depth;
    
    return gp;
}

@end
