//
//  HudLayer.h
//  greedy
//
//  Created by gareth stokes on 7/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "LifeMeter.h"
#import "GameLayer.h"
#import "OptionsMenuLayer.h"

@interface HudLayer : CCLayer {
  GameLayer *_gameLayer;
  LifeMeter *_lifeMeter;
  CCLabelTTF *_debugLabel;
  CCLabelTTF *_toggleLabel;
  OptionsMenuLayer *_optionsMenu;
  bool _settingsOpen;
  int _countdown;
  CCLabelAtlas *_countdownLabel;
}

@property (nonatomic, assign) LifeMeter *lifeMeter;

- (id) initWithGameLayer:(GameLayer*)gameLayer;

- (void) createLifeMeter: (CGSize)size;
- (void) updateCountdownClock:(id)sender;
- (void) createCountdownLabel;


@end
