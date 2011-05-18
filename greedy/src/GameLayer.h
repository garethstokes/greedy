//
//  GreedyGameLayer.h
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "cocos2d.h"
#import "chipmunk.h"
#import "GameEnvironment.h"
#import "Greedy.h"
#import "Background.h"

@interface GameLayer : CCLayer
{
  GameEnvironment *_environment;
  Greedy *_greedy;
  NSMutableArray *_asteroids;
  CGPoint _lastPosition;
  Background *_background;
}

@property (nonatomic, retain) Greedy *greedy;

- (void) step:(ccTime)dt;
- (id) initWithBackground:(Background *) background;

@end
