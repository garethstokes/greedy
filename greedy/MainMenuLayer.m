//
//  MainMenuLayer.m
//  greedy
//
//  Created by Richard Owen on 28/08/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "MainMenuLayer.h"
#import "CCSprite.h"
#import "OptionsMenuLayer.h"
#import "ChooseLevelLayer.h"


@implementation MainMenuLayer

@synthesize menuMain = _menuMain;

- (id)init
{
  self = [super init];
  if (self) {
    CCSprite *background = [CCSprite spriteWithFile:@"mainmenu_bg.png"];
    [background setPosition:ccp(160, 240)];
    [self addChild:background];
    
    CCSprite *textVoyage = [CCSprite spriteWithFile:@"voyage_text.png"];
    [textVoyage setPosition:ccp(160, 365 )];
    [self addChild:textVoyage];    
    
    // ADD MENU ITEMS
    CCMenuItemImage *menuOption = [CCMenuItemImage itemFromNormalImage:@"options.png" 
                                                         selectedImage:@"options_on_tap.png"
                                                                target:self 
                                                              selector:@selector(menuOptionTapped:)];
    
    
    CCMenuItemImage *menuPlay = [CCMenuItemImage itemFromNormalImage:@"play.png" 
                                                       selectedImage:@"play_on_tap.png"
                                                              target:self 
                                                            selector:@selector(menuPlayTapped:)];
    
    _menuMain = [CCMenu menuWithItems:menuOption, menuPlay, nil];

    [_menuMain setPosition:ccp(160,60)];
    [_menuMain alignItemsHorizontallyWithPadding:16];
    [self addChild:_menuMain];
  }
  
  return self;
}

- (void)menuOptionTapped:(id)sender { 
  OptionsMenuLayer *optionsMenu = [[OptionsMenuLayer alloc]init:NO];
  [self addChild:optionsMenu];
}

- (void)menuPlayTapped:(id)sender {
  ChooseLevelLayer *chooseLevel = [[ChooseLevelLayer alloc] initWithColor:ccc4(35,31,32,255) width:320 height:480];
  [self addChild:chooseLevel];
}

@end
