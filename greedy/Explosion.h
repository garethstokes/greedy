//
//  Explosion.h
//  greedy
//
//  Created by Richard Owen on 20/10/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"

#define EXPLOSION_START_TIME 1.0f   // speed of explosion in seconds
#define EXPLOSION_FADE_TIME  2.0f   // duration of fade out and second scale
#define FLAME_SCALE_START 0.1f      // start at 10%
#define FLAME_SCALE_EXPLODE 2.0f    // explode out to 200%
#define FLAME_SCALE_FADE 4.0f       // fade out to 400%

@interface Explosion : CCSprite {
  CCSprite *animSpr;
  CCAction *animAction;
  NSMutableArray * allParts;
  CCLayer * layer_;
}

-(id) initWithPosition:(CGPoint)position inLayer:(CCLayer *)inLayer;
- (void) setOpacity:(GLubyte)opacity;

@end
