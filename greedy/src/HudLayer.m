//
//  HudLayer.m
//  greedy
//
//  Created by gareth stokes on 7/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "HudLayer.h"
#import "MenuScene.h"
#import "GameConfig.h"
#import "OptionsMenuLayer.h"

@implementation HudLayer

@synthesize lifeMeter = _lifeMeter;

- (id) init
{
  return [self initWithGameLayer:nil];
}

- (id) initWithGameLayer:(GameLayer*)gameLayer
{
  NSLog(@"HudLayer Init");
  //if (!(self=[super initWithColor:(ccColor4B){64, 64, 128, 64}]))
  if (!(self=[super init]))
  {
    return nil;
  }
  
  CGSize size = [[CCDirector sharedDirector] winSize];
  [self setPosition:ccp(0, size.height - 45)];
  [self setContentSize:CGSizeMake(size.width, 45)];
  
  // background sprite
  CCSprite *background = [CCSprite spriteWithFile:@"hud_bg.png"];
  [background setPosition:ccp(size.width /2,25)];
  [self addChild:background z:-1];
  
  CCMenuItemImage *pause = [CCMenuItemImage itemFromNormalImage:@"pause_btn_off.png" 
                                                  selectedImage:@"pause_btn_down.png" 
                                                         target:self 
                                                       selector:@selector(openSettings:)];
  
  CCMenu *menu = [CCMenu menuWithItems: pause, nil];
  [menu setPosition:CGPointMake(25, 25)];
  [self addChild:menu];
  
  [self createLifeMeter: size];
  _gameLayer = gameLayer;
  
  return self;
}

- (void) createLifeMeter: (CGSize) size  {
  
  //Create Life Meter art work
  _lifeMeter = [[[LifeMeter alloc] initLifeMeter] retain];
  _lifeMeter.position = ccp(size.width /2, 25);
  [_lifeMeter setLifeLevel:10];
  
  [self addChild:_lifeMeter];
}

- (void)restartGame:(id)sender
{
  [[CCDirector sharedDirector] replaceScene:[MenuScene scene]];
}

- (void)debugGame:(id)sender
{
  if (_gameLayer != nil)
    [_gameLayer toggleDebug];
}

- (void)openSettings:(id)sender
{
  if (_optionsMenu == nil)
  {
    [[CCDirector sharedDirector] pause];
    _optionsMenu = [[OptionsMenuLayer alloc] init];
    [self.parent addChild:_optionsMenu z:100];
    return;
  }

  [self.parent removeChild:_optionsMenu cleanup:YES];
  _optionsMenu = nil;
  [[CCDirector sharedDirector] resume];
}

- (void) dealloc
{
  NSLog(@"Dealloc HudLayer");
  [_lifeMeter release];
  [_optionsMenu release];
  [super dealloc];
}

@end