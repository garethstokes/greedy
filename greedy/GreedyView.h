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

  cpShape *_shape;
  cpShape *_iris[16];
  cpShape *_irisBoundingCircle;
  cpShapeNode  *_eyeBall;
  int _thrusting;
  int _feeding;
  CCAction *_thrustAction;
  
  NSMutableArray *_flameFrames;
  CCSpriteBatchNode *_batch;
  
  SpaceManagerCocos2d *_manager;
  
  //animation
  CCAnimation *_animationOpenUp;
  CCAnimate *_actionOpenUp;
  CCAnimate *_actionCloseDown;
  CCAnimate *_actionFlame;
  
}

- (void) createSprites;
- (id) initWithShape:(cpShape *)shape manager:(SpaceManagerCocos2d *)manager;
- (void) step:(ccTime) delta;
- (void) setThrusting:(int)value;
- (void) updateFeeding:(int) value;
- (BOOL) isThrusting;
- (float) getEyePositionForCurrentSprite;
- (void) addCrazyEye:(SpaceManagerCocos2d *)manager;
- (void) removeCrazyEyeAndContainer;

//animation commands
-(void) goIdle:(id)sender;
-(void) openUp;
-(void) closeDown;



@end
