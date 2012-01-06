//
//  LifeMeter.h
//  greedy
//
//  Created by Richard Owen on 29/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "SpriteHelperLoader.h"

@interface LifeMeter : CCSprite {
    CCSprite * _lifeBars;
    
    CCSprite * _spriteGlow;
    
    CCSpriteBatchNode *_lifeMeterBatchNode;
}

- (id) initLifeMeter:(SpriteHelperLoader *) loader;
- (void) setLifeLevel:(int) level;
- (void) hit;

@end
