//
//  GreedyGameLayer.h
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "cocos2d.h"
#import "chipmunk.h"
#import "Greedy.h"
#import "AsteroidField.h"


@interface GameLayer : CCLayer
{

  Greedy *_greedy;
  AsteroidField *_asteroidField;
  CGPoint _lastPosition;
  
  CCLayer* _debugLayer;
  
  float accelX;
  float accelY;
  float accelZ;
}

@property (nonatomic, retain) Greedy *greedy;

- (void) step:(ccTime)dt;
- (id) initWithEnvironment:(GameEnvironment *) environment;
- (void) toggleDebug;

@end
