//
//  LeafDrawCommand.h
//  LSystem-Cocos2d
//
//  Created by Andrew O'Connor on 31/03/2013.
//
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "LSystem.h"

@interface LeafDrawCommand : NSObject <LSysCommand>

@property (nonatomic, retain) CCRenderTexture *rt;

@end
