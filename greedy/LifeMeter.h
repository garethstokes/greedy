//
//  LifeMeter.h
//  greedy
//
//  Created by Richard Owen on 29/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"

@interface LifeMeter : CCSprite {
  CCSprite * _lifeBars;
  
  CCSpriteBatchNode *_lifeMeterBatchNode;
}

- (id) initLifeMeter;
- (void) setLifeLevel:(int) level;

@end
