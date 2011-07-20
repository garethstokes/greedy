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

+ (id) scene
{
  MenuScene *menu = [[MenuScene alloc] init];
  
  ChooseLevelLayer *chooseLevel = [[ChooseLevelLayer alloc] init];
  menu.chooseLevel = chooseLevel;
  [menu addChild:chooseLevel];
  
  return menu;
}

@end
