//
//  ChooseLevelLayer.m
//  greedy
//
//  Created by Gareth Stokes on 13/07/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "ChooseLevelLayer.h"
#import "GameScene.h"
#import "MainMenuLayer.h"

@implementation ChooseLevelLayer

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ChooseLevelLayer *layer = [[ChooseLevelLayer alloc] initWithColor:ccc4(35,31,32,255) width:320 height:480];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    [layer release];
	
	// return the scene
	return scene;
}

- (void) createButton:(SpriteHelperLoader *)loader atPosition:(CGPoint)position withTag:(int)tag
{
  int currentLevel = [[SettingsManager sharedSettingsManager] getInt:@"current_level" withDefault:1];
  if (tag > currentLevel) return;
  
  CCMenuItemImage *image = [CCMenuItemImage itemFromNormalSprite:[loader spriteWithUniqueName:@"levelReady" atPosition:ccp(0,0) inLayer:nil]
                                                  selectedSprite:[loader spriteWithUniqueName:@"levelReady" atPosition:ccp(0,0) inLayer:nil]
                                                          target:self 
                                                        selector:@selector(buttonTapped:)];
  [image setTag:tag];
  
  CCMenu *starMenu = [CCMenu menuWithItems:image, nil];
  starMenu.positionInPixels = position;
  [self addChild:starMenu];
}

- (void)loadLevelButtons:(SpriteHelperLoader *) loader
{
  // set a button for each level
  [self createButton:loader atPosition:ccp(59, 331) withTag:1];
  [self createButton:loader atPosition:ccp(124, 331) withTag:2];
  [self createButton:loader atPosition:ccp(189, 331) withTag:3];
  [self createButton:loader atPosition:ccp(253, 331) withTag:4];
    
  [self createButton:loader atPosition:ccp(59, 223) withTag:5];
  [self createButton:loader atPosition:ccp(124, 223) withTag:6];
  [self createButton:loader atPosition:ccp(189, 223) withTag:7];
  [self createButton:loader atPosition:ccp(253, 223) withTag:8];
  
  [self createButton:loader atPosition:ccp(59, 114) withTag:9];
  [self createButton:loader atPosition:ccp(124, 114) withTag:10];
  [self createButton:loader atPosition:ccp(189, 114) withTag:11];
  [self createButton:loader atPosition:ccp(253, 114) withTag:12];
}

- (void)loadLevelBlocks:(SpriteHelperLoader *) loader
{
  for (int i = 0; i < 4; i++)
        {
            int blocks = [[SettingsManager sharedSettingsManager] getInt:@"Level1_Block_count" withDefault:(arc4random() % 4)];
            
            for(int j = 0; j < blocks; j++)
            {
                [loader spriteWithUniqueName:@"scoreBlock" atPosition:ccp(58 + (i * 65) + (j * 8), 325 + (j * 8)) inLayer:self];
            }
        }

}

- (id) initWithColor:(ccColor4B)color width:(GLfloat)w  height:(GLfloat) h
{
    self = [super initWithColor:color width:w height:h];
    
    if (self) {
        SpriteHelperLoader * newLoader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"chooselevel"];
        
        [newLoader spriteWithUniqueName:@"background" atPosition:ccp(150, 245) inLayer:self];
        
        [self loadLevelButtons: newLoader];
        
        [self loadLevelBlocks: newLoader];

        CCMenu *menu = [CCMenu menuWithItems:[CCMenuItemImage itemFromNormalSprite:[newLoader spriteWithUniqueName:@"btnBackDown" atPosition:ccp(0,0) inLayer:nil]
                                                                    selectedSprite:[newLoader spriteWithUniqueName:@"btnBackDown" atPosition:ccp(0,0) inLayer:nil]
                                                                            target:self 
                                                                          selector:@selector(buttonBackToMainMenu:)], nil];
        [menu setPosition:ccp(54, 48)];

        [self addChild:menu];
        
        [newLoader release];
    }
    
    return self;
}

- (void)buttonTapped:(id)sender {
    CCMenuItemImage *image = (CCMenuItemImage *)sender;
    int level = [image tag];
    [[CCDirector sharedDirector] replaceScene:[GameScene sceneWithLevel:level]];
}

- (void)buttonBackToMainMenu:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[MainMenuLayer scene]];
}

- (void)dealloc {
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

@end
