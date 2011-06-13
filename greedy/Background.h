//
//  Background.h
//  greedy
//
//  Created by gareth stokes on 8/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "GameEnvironment.h"

@interface Background : CCLayer {
  CCParallaxNode *_parallax;  
}

- (id) initWithEnvironment:(GameEnvironment *)environment;

@end
