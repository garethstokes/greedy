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

@implementation GameScene

@synthesize environment = _environment;
@synthesize engine = _engine;
@synthesize background = _background;
@synthesize gameLayer = _gameLayer;
@synthesize hudLayer = _hudLayer;

+(id) scene
{
	// 'scene' is an autorelease object.
	GameScene *scene = [GameScene node];
  
  //Create the environment
  scene->_environment = [[GameEnvironment alloc] init];
  
  //create the engine
  scene->_engine = [[GDKaosEngine alloc] initWorldSize:CGSizeMake(500.0, 1800.0) withDensity:10.0f];  
  
  // star layer background
  scene->_background = [[Background alloc] initWithEnvironment:scene->_environment];
  [scene addChild:scene->_background z:0];
  
  //balsamic 1
  CCSprite *balsamic = [CCSprite spriteWithFile:@"mid_z_layer_grad_vignette_2.png"];
  //balsamic.position = ccp(0.0,0.0);
  [scene addChild:balsamic z:1];
  
  //HUD
  scene->_hudLayer = [[HudLayer alloc] init];
  
  
  //Game Layer
  scene.gameLayer = [[GameLayer alloc] initWithEnvironment:scene->_environment];
  [scene addChild:scene.gameLayer z:10];
  
  //balsamic 2
  //Balsamic *vinegarette = [[[Balsamic alloc] init] autorelease];
  //vinegarette.position = ccp(0.0,0.0);
  //[scene addChild:vinegarette z:49];
  

  [scene addChild:scene->_hudLayer z:50];
  
	// return the scene
	return scene;
}

- (void) dealloc
{
  NSLog(@"Dealloc GameScene");
  [_hudLayer release];
  [_gameLayer release];
  [_background release];
  [_engine release];
  [_environment release];
  [self removeAllChildrenWithCleanup:YES];
  [super dealloc];
}

@end
