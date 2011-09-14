//
//  GreedyGameScene.h
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameEnvironment.h"
#import "GDKaosEngine.h"
#import "Background.h"
#import "GameLayer.h"
#import "HudLayer.h"
#import "ScoreCard.h"
#import "DeathCard.h"

@interface GameScene : CCScene {
  GameEnvironment *_environment;
  GDKaosEngine *_engine;
  Background *_background;
  GameLayer *_gameLayer;
  HudLayer *_hudLayer;
  ScoreCard *_scorecard;
  DeathCard *_deathcard;
  GameScene *_scene;
}

@property (nonatomic, retain) GameEnvironment *environment;
@property (nonatomic, retain) GDKaosEngine *engine;
@property (nonatomic, retain) Background *background;
@property (nonatomic, retain) GameLayer *gameLayer;
@property (nonatomic, retain) HudLayer *hudLayer;
@property (nonatomic, retain) GameScene *scene;

+ (id) sceneWithLevel:(int)level;
+ (GameScene *) current;

- (void) showScore:(int) score time:(ccTime)time;
- (void) showDeath;
- (void) restart;

@end
