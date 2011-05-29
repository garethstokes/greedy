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

@interface HudLayer : CCLayerColor {
  LifeMeter *_lifeMeter;
}

@property (retain, nonatomic) LifeMeter *lifeMeter;

- (void) restartGame:(id)sender;

@end
