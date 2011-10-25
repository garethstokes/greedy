//
//  GreedyView.h
//  greedy
//
//  Created by gareth stokes on 1/06/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "SpaceManager.h"
#import "SpaceManagerCocos2d.h"
#import "GameConfig.h"

@interface GreedyView : CCNode {
  CCSprite *_radar;
  cpCCSprite *_sprite;
  CCSprite *_flames;
  cpShape *_radarShape;
  
  cpShape *_shape;

  int _thrusting;
  int _feeding;
  CCAction *_thrustAction;
  
  NSMutableArray *_flameFrames;
  CCSpriteBatchNode *_batch;
  
  SpaceManagerCocos2d *_manager;
  
  //animation
  CCAnimation *_animationOpenUp;
  CCAnimate *_actionOpenUp;
  CCActionInterval *_actionCloseDown;
  CCAnimate *_actionFlame;
  CCAnimate *_actionWobble;
  
  
  //explosion
  CCSpriteBatchNode * _batchExplosion;
  CCSpriteBatchNode * _batchExplosionSexy;
  cpCCSprite *_spriteExplosion1;
  
  //ring of death
  CCSpriteBatchNode *_batchRingOfDeath;
  CCSprite *spriteRingOfDeath;
}

- (void) createSprites;
- (id) initWithShape:(cpShape *)shape manager:(SpaceManagerCocos2d *)manager radar:(cpShape *)radar;
- (void) step:(ccTime) delta;
- (void) setThrusting:(int)value;
- (void) updateFeeding:(int) value;
- (BOOL) isThrusting;

//radar stuff
- (void) startRadar;
- (void) stopRadar;

//animation commands
-(void) goIdle:(id)sender;
-(void) openUp;
-(void) closeDown;
-(void) explode;



@end
