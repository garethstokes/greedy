//
//  GreedyGameScene.m
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "GreedyGameScene.h"

@implementation GreedyGameScene

@synthesize gameLayer = _gameLayer;
@synthesize hudLayer = _hudLayer;

+ (id) scene
{
  GreedyGameScene *scene = [GreedyGameScene node];
    
  scene.gameLayer = [[[GreedyGameLayer alloc] init] autorelease];
  [scene addChild:scene.gameLayer z:5];
  
  scene.hudLayer = [[[HudLayer alloc] init] autorelease];
  [scene addChild:scene.hudLayer z:0];
    
  return scene;
}

@end
