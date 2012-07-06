//
//  DrawState.h
//  LSystem
//
//  Created by Andrew O'Connor on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface DrawState : NSObject

@property (nonatomic, assign) CGPoint translation;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) ccColor3B lineColor;
@property (nonatomic, assign) CGFloat segmentSize;

+(id) state;
+(id) stateWithState:(DrawState*)state;

@end
