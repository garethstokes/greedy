//
//  GreedyView.h
//  greedy
//
//  Created by gareth stokes on 1/06/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "SpaceManager.h"

@interface GreedyView : CCNode {
  CCSprite *_radar;
  CCSprite *_sprite;

  int _thrusting;
}

@property (nonatomic) int thrusting;

- (id) initWithShape:(cpShape *)shape;
- (void) step:(ccTime) delta;
- (void) updateFeeding:(int) value;

@end
