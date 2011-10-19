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
	ChooseLevelLayer *layer = [[[ChooseLevelLayer alloc] initWithColor:ccc4(35,31,32,255) width:320 height:480] autorelease];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void)loadLevelButtons {
    // ADD MENU ITEMS
    
    CCMenu *menu = [CCMenu menuWithItems:nil];

    for (int i = 0; i < 4; i++)
    {
        CCMenuItemImage *image = [CCMenuItemImage itemFromNormalSprite:[_loader spriteWithUniqueName:@"levelReady" atPosition:ccp(0,0) inLayer:nil]
                                                        selectedSprite:[_loader spriteWithUniqueName:@"levelReady" atPosition:ccp(0,0) inLayer:nil]
                                                                target:self 
                                                              selector:@selector(buttonTapped:)];
        
        [image setTag:(i + 1)];
        [menu addChild:image];
    }
    [menu setPosition:ccp(156, 331)];
    [menu alignItemsHorizontallyWithPadding:4];
    [self addChild:menu];
    
}
- (void)loadLevelBlocks {
  for (int i = 0; i < 4; i++)
        {
            int blocks = [[SettingsManager sharedSettingsManager] getInt:@"Level1_Block_count" withDefault:(arc4random() % 4)];
            
            for(int j = 0; j < blocks; j++)
            {
                [_loader spriteWithUniqueName:@"scoreBlock" atPosition:ccp(58 + (i * 65) + (j * 8), 325 + (j * 8)) inLayer:self];
            }
        }

}

- (id) initWithColor:(ccColor4B)color width:(GLfloat)w  height:(GLfloat) h
{
    self = [super initWithColor:color width:w height:h];
    
    if (self) {
        _loader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"chooselevel"];
        
        [_loader spriteWithUniqueName:@"background" atPosition:ccp(150, 245) inLayer:self];
        
        [self loadLevelButtons];
        
        [self loadLevelBlocks];

        CCMenu *menu = [CCMenu menuWithItems:[CCMenuItemImage itemFromNormalSprite:[_loader spriteWithUniqueName:@"btnBackDown" atPosition:ccp(0,0) inLayer:nil]
                                                                    selectedSprite:[_loader spriteWithUniqueName:@"btnBackDown" atPosition:ccp(0,0) inLayer:nil]
                                                                            target:self 
                                                                          selector:@selector(buttonBackToMainMenu:)], nil];
        [menu setPosition:ccp(54, 48)];
        [self addChild:menu];
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
@end
