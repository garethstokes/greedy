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

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenuLayer *layer = [MainMenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init
{
  self = [super init];
  if (self) {
      
    SpriteHelperLoader *loader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"mainmenu"];
    
    [loader spriteWithUniqueName:@"Default" atPosition:ccp(160,240) inLayer:self];

    // ADD MENU ITEMS
    CCMenuItemImage *menuOption = [CCMenuItemImage 
                                   itemFromNormalSprite:[loader spriteWithUniqueName:@"options" atPosition:ccp(0,0) inLayer:nil]
                                   selectedSprite:[loader spriteWithUniqueName:@"options_on_tap" atPosition:ccp(0,0) inLayer:nil] 
                                   target:self 
                                   selector:@selector(menuOptionTapped:)];
      
      
    CCMenuItemImage *menuPlay = [CCMenuItemImage 
                                 itemFromNormalSprite:[loader spriteWithUniqueName:@"play" atPosition:ccp(0,0) inLayer:nil]
                                 selectedSprite:[loader spriteWithUniqueName:@"play_on_tap" atPosition:ccp(0,0) inLayer:nil] 
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
  OptionsMenuLayer *optionsMenu = [[[OptionsMenuLayer alloc]init:NO] autorelease];
  [self addChild:optionsMenu];
}

- (void)menuPlayTapped:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[ChooseLevelLayer scene]];
}

@end
