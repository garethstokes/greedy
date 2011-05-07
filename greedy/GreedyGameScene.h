//
//  GreedyGameScene.h
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GreedyGameLayer.h"
#import "HudLayer.h"

@interface GreedyGameScene : CCScene {
  GreedyGameLayer *_gameLayer;
  HudLayer *_hudLayer;
}

@property (nonatomic, retain) GreedyGameLayer *gameLayer;
@property (nonatomic, retain) HudLayer *hudLayer;

+ (id) scene;

@end
