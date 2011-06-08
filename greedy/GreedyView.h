//
//  GreedyView.h
//  greedy
//
//  Created by gareth stokes on 1/06/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "SpaceManagerCocos2d.h"
#import "GameConfig.h"

@interface GreedyView : CCNode {
  CCSprite *_radar;
  CCSprite *_sprite;
  cpShape *_iris[16];
  cpShapeNode  *_eyeBall;
  int _thrusting;
}

@property (nonatomic) int thrusting;

- (id) initWithShape:(cpShape *)shape manager:(SpaceManagerCocos2d *)manager;
- (void) step:(ccTime) delta;
//- (void) updateFeeding:(int) value;

@end
