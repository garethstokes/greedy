//
//  MenuScene.m
//  greedy
//
//  Created by Gareth Stokes on 13/07/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "MenuScene.h"

@implementation MenuScene

@synthesize chooseLevel = _chooseLevel;
@synthesize mainMenu = _mainMenu;

+ (id) scene
{
  MenuScene *menu = [[[MenuScene alloc] init] autorelease];
  
  menu.mainMenu = [[MainMenuLayer alloc] init];
  [menu addChild:menu.mainMenu];
  
  //show main menu
  //[menu showChooseLevel];
  
  return menu;
}

- (void) showMainMenu{
  
}

- (void) showChooseLevel{
  [_mainMenu menuPlayTapped:self];
}

@end
