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

@implementation GameScene

@synthesize environment = _environment;
//@synthesize engine = _engine;
@synthesize background = _background;
@synthesize gameLayer = _gameLayer;
@synthesize hudLayer = _hudLayer;
@synthesize scene = _scene;

+(id) sceneWithLevel:(int)level
{
  CCLOG(@" GameScene: sceneWithLevel");
  
	// 'scene' is an autorelease object.
	GameScene *scene = [GameScene node];
  
  //Create the environment
  scene->_environment = [[GameEnvironment alloc] init];
  
  //create the engine
  scene->_engine = [[GDKaosEngine alloc] initWorldSize:CGSizeMake(500.0, 1800.0) withDensity:10.0f];  
  
  // star layer background
  scene->_background = [[Background alloc] initWithEnvironment:scene->_environment];
  [scene addChild:scene->_background z:0];

  //Game Layer
  scene->_gameLayer = [[GameLayer alloc] initWithEnvironment:scene->_environment level:level];
  [scene addChild:scene.gameLayer z:10];
    
  //HUD
  scene->_hudLayer = [[HudLayer alloc] initWithGameLayer:scene.gameLayer];
  [scene addChild:scene->_hudLayer z:50];
  
  //scene->_scorecard = [[ScoreCard alloc] initWithScore:1000 level:1 time:12.34];
  //[scene addChild:scene->_scorecard  z:100];
  
  [scene->_gameLayer startLevel];
  
	// return the scene
  scene->_level = level;
	return scene;
}

- (void) showScore:(int) score time:(ccTime)time
{
  if(_scorecard != nil) return;
  
  GameScene *scene = (GameScene *)[[CCDirector sharedDirector] runningScene];
  [self removeChild:scene->_hudLayer cleanup:YES];
  
  _scorecard = [[ScoreCard alloc] initWithScore:score level:1 time:time];
  [self addChild:_scorecard  z:100];
}

- (void) showDeath
{
  if(_deathcard != nil) return;
  
  GameScene *scene = (GameScene *)[[CCDirector sharedDirector] runningScene];
  [self removeChild:scene->_hudLayer cleanup:YES];
  
  _deathcard = [[DeathCard alloc] init];
  [self addChild:_deathcard  z:100];
}

- (GameScene *) sceneFromCurrent
{
  return [GameScene sceneWithLevel:_level];
}

- (void) dealloc
{
  NSLog(@"Dealloc GameScene");
  [_scorecard release];
  [_deathcard release];
  [_hudLayer release];
  [_gameLayer release];
  [_background release];
  //[_engine release];
  [_environment release];
  [self removeAllChildrenWithCleanup:YES];
  [super dealloc];
}

@end
