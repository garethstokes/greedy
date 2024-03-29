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
  HudLayer *hudLayer;
  ScoreCard *_scorecard;
  DeathCard *_deathcard;
  GameScene *scene;
  int level;
}

@property (nonatomic, retain) HudLayer *hudLayer;
@property (nonatomic, readonly) int Level;

+ (id) sceneWithLevel:(int)level;

- (void) showScore:(int) score time:(ccTime)time;
- (void) showDeath;
- (GameScene *) sceneFromCurrent;
- (void) removeHud;

@end
