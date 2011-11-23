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

#define kOptionsMenu 10000

@interface HudLayer : CCLayer {
  LifeMeter *_lifeMeter;
  CCLabelTTF *_debugLabel;
  CCLabelTTF *_toggleLabel;
  int _countdown;
  CCLabelAtlas *_countdownLabel;
}

@property (nonatomic, assign) LifeMeter *lifeMeter;
@property (nonatomic, readonly) int CountDown;

- (id) initWithGameLayer;

- (void) createLifeMeter: (CGSize)size;
- (void) updateCountdownClock:(id)sender;
- (void) createCountdownLabel;
- (void) stop;


@end
