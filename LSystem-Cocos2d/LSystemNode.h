//
//  LSystemNode.h
//  LSystem-Cocos2d
//
//  Created by Andrew O'Connor on 07/07/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LSystemNode : CCNode {
    
}

+(id) lsystemWithRules:(NSDictionary*)rules;
-(id) initWithRules:(NSDictionary*)rules;

@end
