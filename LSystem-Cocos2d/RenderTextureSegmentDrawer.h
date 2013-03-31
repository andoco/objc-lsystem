//
//  RenderTextureSegmentDrawer.h
//  LSystem
//
//  Created by Andrew O'Connor on 06/07/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "LSystem.h"

@interface RenderTextureSegmentDrawer : CCNode <SegmentDrawer> {
    
}

@property (nonatomic, retain) CCRenderTexture *rt;

@end
