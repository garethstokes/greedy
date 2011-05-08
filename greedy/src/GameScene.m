//
//  GreedyGameScene.m
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "GameScene.h"
#import "Background.h"

@implementation GameScene

@synthesize gameLayer = _gameLayer;
@synthesize hudLayer = _hudLayer;

+ (id) scene
{
  GameScene *scene = [GameScene node];
  
  scene.gameLayer = [[[GameLayer alloc] init] autorelease];
  [scene addChild:scene.gameLayer z:10];
  
  scene.hudLayer = [[[HudLayer alloc] init] autorelease];
  [scene addChild:scene.hudLayer z:100];
    
  return scene;
}

@end
