//
//  HudLayer.m
//  greedy
//
//  Created by gareth stokes on 7/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "HudLayer.h"
#import "GameScene.h"

@implementation HudLayer

- (id) init
{
  if (!(self=[super initWithColor:(ccColor4B){64, 64, 128, 64}]))
  {
    return nil;
  }
  
  CGSize size = [[CCDirector sharedDirector] winSize];
  [self setPosition:ccp(0, size.height - 30)];
  [self setContentSize:CGSizeMake(size.width, 30)];
  
  CCLabelTTF *restartLabel = [CCLabelTTF labelWithString:@"restart" 
                                         fontName:@"Helvetica" 
                                         fontSize:16];
  
  CCMenuItem *restartButton = [CCMenuItemLabel
                               itemWithLabel:restartLabel
                               target:self 
                               selector:@selector(restartGame:)];

  [restartButton setPosition:CGPointMake(210, 15)];
  
  CCMenu *menu = [CCMenu menuWithItems:restartButton, nil];
  [menu setPosition:CGPointMake(240, 0)];
  [self addChild:menu];
  
  return self;
}

- (void)restartGame:(id)sender
{
  //GreedyGameScene *current = (GreedyGameScene *)[[CCDirector sharedDirector] runningScene];
  [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
}

@end
