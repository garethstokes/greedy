//
//  HudLayer.m
//  greedy
//
//  Created by gareth stokes on 7/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "HudLayer.h"
#import "GameScene.h"
#import "GameConfig.h"

@implementation HudLayer

@synthesize lifeMeter = _lifeMeter;

- (void) CreateLifeMeter: (CGSize) size  {
  
  //Create Life Meter art work
  _lifeMeter = [[[LifeMeter alloc] initLifeMeter] retain];
  _lifeMeter.scaleX = 98.0f / _lifeMeter.contentSizeInPixels.width;
  _lifeMeter.scaleY = 12.0f / _lifeMeter.contentSizeInPixels.height;
  _lifeMeter.position = ccp(size.width - 58, 15);
  [_lifeMeter setLifeLevel:10];
  
  [self addChild:_lifeMeter];
}

- (id) init
{
  return [self initWithGameLayer:nil];
}

- (id) initWithGameLayer:(GameLayer*)gameLayer
{
  
  NSLog(@"HudLayer Init");
  if (!(self=[super initWithColor:(ccColor4B){64, 64, 128, 64}]))
  {
    return nil;
  }
  
  CGSize size = [[CCDirector sharedDirector] winSize];
  [self setPosition:ccp(0, size.height - 45)];
  [self setContentSize:CGSizeMake(size.width, 45)];
  
  CCLabelTTF *restartLabel = [CCLabelTTF labelWithString:@"restart" 
                                                fontName:@"Helvetica" 
                                                fontSize:16];
  
  CCMenuItem *restartButton = [CCMenuItemLabel
                               itemWithLabel:restartLabel
                               target:self 
                               selector:@selector(restartGame:)];
  
  [restartButton setPosition:CGPointMake(45, 20)];
  
  _debugLabel = [CCLabelTTF labelWithString:@"Show Debug" 
                                   fontName:@"Helvetica" 
                                   fontSize:16];
  
  CCMenuItem *debugButton = [CCMenuItemLabel
                             itemWithLabel:_debugLabel
                             target:self 
                             selector:@selector(debugGame:)];
  
  [debugButton setPosition:CGPointMake(145, 20)];
  
  _toggleLabel = [CCLabelTTF labelWithString:@"Toggle -->" 
                                    fontName:@"Helvetica" 
                                    fontSize:16];
  
  CCMenuItem *toggleButton = [CCMenuItemLabel
                              itemWithLabel:_toggleLabel
                              target:self 
                              selector:@selector(toggleGame:)];
  
  [toggleButton setPosition:CGPointMake(145, 0)];
  
  CCMenu *menu = [CCMenu menuWithItems:restartButton, toggleButton, debugButton, nil];
  [menu setPosition:CGPointMake(4, 0)];
  [self addChild:menu];
  
  [self CreateLifeMeter: size];
  
  _gameLayer = gameLayer;
  
  return self;
}

- (void)restartGame:(id)sender
{
  [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
}

- (void)debugGame:(id)sender
{
  if (_gameLayer != nil)
    [_gameLayer toggleDebug];
}

- (void)toggleGame:(id)sender
{
  static BOOL toggleSwitch = NO;
  if(toggleSwitch)
  {
    [_toggleLabel setString:@"Toggle <--"];
    
  }else{
    [_toggleLabel setString:@"Toggle -->"];
  };
  toggleSwitch = !toggleSwitch;
  [_gameLayer toggleController];
}

- (void) dealloc
{
  NSLog(@"Dealloc HudLayer");
  [_lifeMeter release];
  [super dealloc];
}
@end
