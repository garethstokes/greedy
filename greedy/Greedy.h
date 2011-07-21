//
//  Greedy.h
//  greedy
//
//  Created by gareth stokes on 7/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "GameObject.h"
#import "cocos2d.h"
#import "chipmunk.h"
#import "GameEnvironment.h"
#import "Asteroid.h"
#import "GreedyView.h"

enum {
	kGreedyOpen1 = 1,
 	kGreedyOpen2 = 2,
  kGreedyOpen3 = 3,
  kGreedyOpen4 = 4,
  kGreedyOpen5 = 5
};

typedef enum {
  kGreedyIdle = 1,
  kGreedyExcited = 2,
  kGreedyDetectedFood = 3,
  kGreedyEating = 4
} GREEDYSTATE;

enum {
  kGreedyThrustNone = 1,
  kGreedyThrustLittle = 2,
  kGreedyThrustMassive = 3
};

@interface Greedy : CCLayer {
  cpShape *_shape;
  cpShape *_radarShape;
  cpVect _lastPosition;
  cpFloat _angle;

  int _feedingCount;
  
  float _score;
  float _fuel;
  
  GreedyView *_view;
}

@property (nonatomic) cpShape *shape;
@property (nonatomic) int feedingCount;
@property (nonatomic) float score;
@property (nonatomic) float fuel;
@property (nonatomic, assign) GreedyView *view;

- (id) initWith:(GameEnvironment *)environment startPos:(cpVect)startPos;
- (void) prestep:(ccTime) delta;
- (void) postStep:(ccTime) delta;
- (void) applyThrust;
- (void) removeThrust;
- (void) setAngle:(cpFloat)value;
- (void) setEatingStatusTo:(int) value;

//radar
- (void) createRadarLine:(SpaceManagerCocos2d *) manager;

//Collision
- (BOOL) handleCollisionWithAsteroid:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (BOOL) handleCollisionRadar:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (BOOL) handleCollisionRadarLine:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;

@end
