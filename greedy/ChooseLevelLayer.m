//
//  ChooseLevelLayer.m
//  greedy
//
//  Created by Gareth Stokes on 13/07/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "ChooseLevelLayer.h"
#import "GameScene.h"

@implementation ChooseLevelLayer

- (id) initWithColor:(ccColor4B)color width:(GLfloat)w  height:(GLfloat) h
{
    self = [super initWithColor:color width:w height:h];
  
    if (self) {
      
      
      CCSprite *background = [CCSprite spriteWithFile:@"choose_level_bg.png"];
      [background setPosition:ccp(150, 245)];
      [self addChild:background];
      
      // ADD MENU ITEMS
      
      CCMenu *menu = [CCMenu menuWithItems:nil];
      
      int y_level = 1;
      for (int i = 0; i < 4; i++)
      {
        CCMenuItemImage *image = [CCMenuItemImage itemFromNormalImage:@"level_ready.png" 
                                                       selectedImage:@"level_ready.png"
                                                              target:self 
                                                            selector:@selector(buttonTapped:)];
        [image setTag:(i + 1)];
        [menu addChild:image];
        
        int offset = (i + 1) % 4;
        if (offset == 0)
        {
          y_level++;
          [menu setPosition:CGPointMake(157, 561 - (120 * y_level - 20))];
          [menu alignItemsHorizontallyWithPadding:4];
          [self addChild:menu];
          menu = [CCMenu menuWithItems:nil];
        }
      }
      
      [menu alignItemsHorizontallyWithPadding:20];
      [self addChild:menu];
    }
    
    return self;
}

- (void)buttonTapped:(id)sender {
  CCMenuItemImage *image = (CCMenuItemImage *)sender;
  int level = [image tag];
  [[CCDirector sharedDirector] replaceScene:[GameScene sceneWithLevel:level]];
}

@end
