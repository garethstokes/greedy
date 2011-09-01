//
//  MenuScene.h
//  greedy
//
//  Created by Gareth Stokes on 13/07/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "MainMenuLayer.h"
#import "ChooseLevelLayer.h"

@interface MenuScene : CCScene{
  MainMenuLayer *_mainMenu;
  ChooseLevelLayer *_chooseLevel;
}

@property (nonatomic, retain) MainMenuLayer *mainMenu;
@property (nonatomic, retain) ChooseLevelLayer *chooseLevel;

+(id) scene;
- (void) showMainMenu;
- (void) showChooseLevel;
@end
