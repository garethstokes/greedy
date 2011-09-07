//
//  OptionsMenuLayer.m
//  greedy
//
//  Created by Richard Owen on 28/08/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "OptionsMenuLayer.h"
#import "CCSlider.h"
#import "SettingsManager.h"

enum nodeTags
{
	kControlTag,
	kSoundTag,
};

@implementation OptionsMenuLayer

- (id)init
{
  self = [super init];
  if (self) {
    CCSprite *background = [CCSprite spriteWithFile:@"options_bg.png"];
    [background setPosition:ccp(160, 240)];
    [self addChild:background];
    
    CCMenuItemImage *menuClose = [CCMenuItemImage itemFromNormalImage:@"close.png" 
                                                        selectedImage:@"close_down.png"
                                                               target:self 
                                                             selector:@selector(menuCloseTapped:)];
    //sound slider
    controlSlider = [CCSlider sliderWithBackgroundFile: @"controlslider_bg.png" thumbFile: @"swtch_slide.png"];
		int controlDirection = [[SettingsManager sharedSettingsManager] getInt:@"controlDirection" withDefault:1];
    [controlSlider setValue:(controlDirection / 1.0)];
    [controlSlider setPosition:ccp(100, 306)];
    controlSlider.tag = kControlTag;
    [self addChild:controlSlider];
		controlSlider.delegate = self;
    
    //sound slider
    soundSlider = [CCSlider sliderWithBackgroundFile: @"slider_bg.png" thumbFile: @"slider.png"];
		float soundLevel = [[SettingsManager sharedSettingsManager] getInt:@"soundLevel" withDefault:100];
    soundSlider.tag = kSoundTag;
    [soundSlider setValue:(soundLevel / 100.0)];
    [soundSlider setPosition:ccp(157, 197)];
    [self addChild:soundSlider];
		soundSlider.delegate = self;
    
    //close button
    CCMenu *menu = [CCMenu menuWithItems:menuClose,nil];
    [menu setPosition:ccp(250,90)];
    [menu alignItemsHorizontallyWithPadding:16];
    [self addChild:menu];
  }
  
  return self;
}

- (void)menuCloseTapped:(id)sender {
  [self.parent removeChild:self cleanup:YES];  
}

- (void) valueChanged: (float) value tag: (int) tag; 
{
  // range sentinel
  value = MIN(value, 1.0f);
  value = MAX(value, 0.0f);
  
  int newval;
  
  switch (tag) {
    case kControlTag:
      if(value > 0.5)
        newval = 1;
      else
        newval = 0;
      controlSlider.delegate = nil;
      [[SettingsManager sharedSettingsManager] setValue:@"controlDirection" newInt:newval];  
      [controlSlider setValue:newval];
      controlSlider.delegate = self;
      break;
      
    case kSoundTag:
      [[SettingsManager sharedSettingsManager] setValue:@"soundLevel" newInt:value * 100];
      break;
      
    default:
      break;
  };
}
- (void)dealloc{
  [controlSlider release];
  [soundSlider release];
  [super dealloc];
}

@end
