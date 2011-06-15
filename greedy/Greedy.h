//
//  Greedy.h
//  greedy
//
//  Created by gareth stokes on 7/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
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

enum {
  kGreedyIdle = 1,
  kGreedyExcited = 2,
  kGreedyDetectedFood = 3,
  kGreedyEating = 4
};

enum {
  kGreedyThrustNone = 1,
  kGreedyThrustLittle = 2,
  kGreedyThrustMassive = 3
};

@interface Greedy : CCLayer {
  cpShape *_shape;
  cpVect _lastPosition;
  cpFloat _angle;
  
  int _feeding;
  
  GreedyView *_view;
}

@property (nonatomic) cpShape *shape;

- (id) initWith:(GameEnvironment *)environment startPos:(cpVect)startPos;
- (void) prestep:(ccTime) delta;
- (void) postStep:(ccTime) delta;
- (void) applyThrust;
- (void) removeThrust;
- (void) setAngle:(cpFloat)value;

@end
