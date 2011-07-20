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

- (id)init
{
    self = [super init];
    if (self) {
      CCSprite *background = [CCSprite spriteWithFile:@"choose_level_bg.png"];
      [background setScale:0.55f];
      [background setPosition:ccp(150, 245)];
      [self addChild:background];
      
      // ADD MENU ITEMS
      
      CCMenu *menu = [CCMenu menuWithItems:nil];
      
      int y_level = 1;
      for (int i = 0; i < 12; i++)
      {
        CCMenuItemImage *image = [CCMenuItemImage itemFromNormalImage:@"level_ready.png" 
                                                       selectedImage:@"level_ready.png"
                                                              target:self 
                                                            selector:@selector(buttonTapped:)];
        [image setScale:0.55f];
        [menu addChild:image];
        
        //[button setContentSize:CGSizeMake(100, 80)];
        
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
  [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
}

@end
