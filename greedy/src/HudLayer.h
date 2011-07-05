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

@interface HudLayer : CCLayerColor {
  GameLayer *_gameLayer;
  LifeMeter *_lifeMeter;
  CCLabelTTF *_debugLabel;
  CCLabelTTF *_toggleLabel;
}

@property (retain, nonatomic) LifeMeter *lifeMeter;

- (id) initWithGameLayer:(GameLayer*)gameLayer;

- (void) restartGame:(id)sender;


@end
