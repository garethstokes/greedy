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
  CGPoint _cameraPosition;
  
  CCLayer* _debugLayer;
  
  GameEnvironment *_environment;
  
  CCSprite *_endPoint;
  
  ccTime _timeleft;
  
  float accelX;
  float accelY;
  float accelZ;
  
  int ACCELORMETER_DIRECTION;
}

@property (nonatomic, retain) Greedy *greedy;

- (void) step:(ccTime)dt;
- (id) initWithEnvironment:(GameEnvironment *) environment level:(int)l;
- (void) toggleDebug;
- (void) moveCameraTo:(CGPoint)point;
- (void) toggleController;
- (void) startLevel;
- (void) start;
- (void) pause;
- (void) stop;
- (void) endLevel;

@end
