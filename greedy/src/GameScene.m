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

@synthesize gameLayer = _gameLayer;
@synthesize hudLayer = _hudLayer;

+ (id) scene
{
  GameScene *scene = [GameScene node];
  
  // background
  Background *background = [[[Background alloc] init] autorelease];
  [scene addChild:background z:0];
  
  CCSprite *balsamic = [CCSprite spriteWithFile:@"mid_z_layer_grad_vignette_2.png"];
  [scene addChild:balsamic z:1];
  
  scene.gameLayer = [[[GameLayer alloc] initWithBackground:background] autorelease];
  [scene addChild:scene.gameLayer z:10];
  
  Balsamic *vinegarette = [[[Balsamic alloc] init] autorelease];
  [scene addChild:vinegarette z:49];
  
  scene.hudLayer = [[[HudLayer alloc] init] autorelease];
  [scene addChild:scene.hudLayer z:50];
    
  return scene;
}

@end
