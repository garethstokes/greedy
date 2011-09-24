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
#import "MenuScene.h"
#import "GameScene.h"
#import "Greedy.h"

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
  _settingsOpen = NO;
  _countdown = 99;
  [self createCountdownLabel];
  [self schedule:@selector(updateCountdownClock:) interval:1.0f];
  return self;
}

- (void) createCountdownLabel {
  CCTexture2DPixelFormat currentFormat = [CCTexture2D defaultAlphaPixelFormat];
  [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
  _countdownLabel = [[CCLabelAtlas labelWithString:@"99" charMapFile:@"orange_numbers.png" itemWidth:10 itemHeight:16 startCharMap:'.'] retain];
  [CCTexture2D setDefaultAlphaPixelFormat:currentFormat];	
  [_countdownLabel setPosition:ccp(288,17)];
  [self addChild:_countdownLabel];
}


- (void) updateCountdownClock:(id)sender
{
  if (_countdown == 0)
  {
    GameScene *scene = (GameScene *)self.parent;
    GameLayer *layer = [scene gameLayer];
    Greedy *greedy = [layer greedy];
    [greedy explode];
    //[scene.gameLayer endLevelWithDeath];
    return;
  }
  
  _countdown--;
  [_countdownLabel setString:[NSString stringWithFormat:@"%.2d", _countdown]];
}

- (void) createLifeMeter: (CGSize) size  {
  
  //Create Life Meter art work
  _lifeMeter = [[[LifeMeter alloc] initLifeMeter] retain];
  _lifeMeter.position = ccp(size.width /2, 25);
  [_lifeMeter setLifeLevel:10];
  
  [self addChild:_lifeMeter];
}


- (void)debugGame:(id)sender
{
  if (_gameLayer != nil)
    [_gameLayer toggleDebug];
}

- (void)openSettings:(id)sender
{
  if (_settingsOpen) return;
  _optionsMenu = [[OptionsMenuLayer alloc] init:YES];
  [self.parent addChild:_optionsMenu z:100];
  _settingsOpen = YES;
}

- (void) dealloc
{
  NSLog(@"Dealloc HudLayer");
  [_lifeMeter release];
  [_optionsMenu release];
  [super dealloc];
}

@end