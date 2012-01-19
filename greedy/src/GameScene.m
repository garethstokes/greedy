//
//  GreedyGameScene.m
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "GameScene.h"
#import "Background.h"
#import "Balsamic.h"
#import "ScoreCard.h"
#import "GameObjectCache.h"

@implementation GameScene

@synthesize hudLayer;
@synthesize Level = level;

+(id) sceneWithLevel:(int)level
{
  CCLOG(@" GameScene: sceneWithLevel");
  
  [GameObjectCache purgeGameObjectCache]; 
  
	// 'scene' is an autorelease object.
	GameScene *scene = [GameScene node];
  
  [[GameObjectCache sharedGameObjectCache] addGameScene: scene];
  scene->level = level;
  
  //Create the environment
  GameEnvironment * envy = [[[GameEnvironment alloc] init] autorelease];
  CCLOG(@"Environment Retain Count: %d", [envy retainCount]);
  
  //Game Layer
  [[GameObjectCache sharedGameObjectCache] addGameLayer:[[[GameLayer alloc] initWithEnvironment:envy level:level] autorelease]];
  [scene addChild:[[GameObjectCache sharedGameObjectCache] gameLayer] z:10];
  
  //HUD
  scene.hudLayer = [[[HudLayer alloc] initWithGameLayer] autorelease];
  [scene addChild:scene.hudLayer z:50];
  
  [[[GameObjectCache sharedGameObjectCache] gameLayer] startLevel];
  
  CCLOG(@"Environment Retain Count: %d", [envy retainCount]);
  
	return scene;
}

- (void) removeHud
{
  [self removeChild:hudLayer cleanup:YES];
}

- (void) showScore:(int) score time:(ccTime)time
{
  if(_scorecard != nil) return;
  
    GameScene *s = (GameScene *)[[CCDirector sharedDirector] runningScene];
    int lev = [s Level];
    
  _scorecard = [[[ScoreCard alloc] initWithScore:score level:lev time:[[self hudLayer] CountDown]] autorelease];
  
  [self addChild:_scorecard  z:100];
}

- (void) showDeath
{
  if(_deathcard != nil) return;
  
  [self removeHud];
  _deathcard = [[[DeathCard alloc] init] autorelease];
  [self addChild:_deathcard  z:100];
}

- (GameScene *) sceneFromCurrent
{
  return [GameScene sceneWithLevel:level];
}

- (void) dealloc
{
  NSLog(@"Dealloc GameScene");
  
  [self removeAllChildrenWithCleanup:YES];
  
  [super dealloc];
  
}

@end
