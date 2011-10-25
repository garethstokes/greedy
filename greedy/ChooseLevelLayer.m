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

- (void)loadLevelButtons:(SpriteHelperLoader *) loader
{
    // ADD MENU ITEMS
    
    CCMenu *menu = [CCMenu menuWithItems:nil];

    for (int i = 0; i < 4; i++)
    {
        CCMenuItemImage *image = [CCMenuItemImage itemFromNormalSprite:[loader spriteWithUniqueName:@"levelReady" atPosition:ccp(0,0) inLayer:nil]
                                                        selectedSprite:[loader spriteWithUniqueName:@"levelReady" atPosition:ccp(0,0) inLayer:nil]
                                                                target:self 
                                                              selector:@selector(buttonTapped:)];
        
        [image setTag:(i + 1)];
        [menu addChild:image];
    }
    [menu setPosition:ccp(156, 331)];
    [menu alignItemsHorizontallyWithPadding:4];
    [self addChild:menu];
    
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
