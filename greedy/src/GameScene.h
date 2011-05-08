//
//  GreedyGameScene.h
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "HudLayer.h"
#import "Background.h"

@interface GameScene : CCScene {
  GameLayer *_gameLayer;
  HudLayer *_hudLayer;
  Background *_background;
}

@property (nonatomic, retain) GameLayer *gameLayer;
@property (nonatomic, retain) HudLayer *hudLayer;

+ (id) scene;

@end
