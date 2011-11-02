//
//  AsteroidShooter.h
//  greedy
//
//  Created by gareth stokes on 5/10/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "AsteroidField.h"

@interface AsteroidShooter : CCNode {
  NSMutableArray *_asteroids;
  GameEnvironment *_environment;
  ccTime _time;
  ccTime _swap;
  int _total;
  CGPoint _position;
}

- (id) initWithAsteroidField:(AsteroidField *)field position:(CGPoint) pos;
- (void) step:(ccTime)delta;

@end