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
#import "GameScene.h"
#import "MainMenuLayer.h"
#import "ChooseLevelLayer.h"
#import "GameObjectCache.h"

enum nodeTags
{
	kControlTag,
	kSoundTag,
    kDebugTag,
};

@implementation OptionsMenuLayer

- (id)init:(bool)inGame
{
    self = [super init];
    if (self) {
        CCSprite *background = [CCSprite spriteWithFile:@"options_bg.png"];
        [background setPosition:ccp(160, 240)];
        [self addChild:background];
        
        //control direction
        controlSlider = [CCSlider sliderWithBackgroundFile: @"controlslider_bg.png" thumbFile: @"swtch_slide.png"];
		int controlDirection = [[SettingsManager sharedSettingsManager] getInt:@"controlDirection" withDefault:0];
        [controlSlider setValue:(controlDirection / 1.0)];
        [controlSlider setPosition:ccp(100, 306)];
        controlSlider.tag = kControlTag;
        [self addChild:controlSlider];
		controlSlider.delegate = self;
        
        //Debug toggle switch
        controlDebug = [CCSlider sliderWithBackgroundFile: @"controlslider_bg.png" thumbFile: @"swtch_slide.png"];
		
        [controlDebug setValue:(controlDirection / 1.0)];
        [controlDebug setPosition:ccp(222, 306)];
        controlDebug.tag = kDebugTag;
        [self addChild:controlDebug];
		controlDebug.delegate = self;        
        
        //sound slider
        soundSlider = [CCSlider sliderWithBackgroundFile: @"slider_bg.png" thumbFile: @"slider.png"];
		float soundLevel = [[SettingsManager sharedSettingsManager] getInt:@"soundLevel" withDefault:100];
        soundSlider.tag = kSoundTag;
        [soundSlider setValue:(soundLevel / 100.0)];
        [soundSlider setPosition:ccp(157, 197)];
        [self addChild:soundSlider];
		soundSlider.delegate = self;
        
        
        CCMenuItemImage *menuClose = [CCMenuItemImage itemFromNormalImage:@"close.png" 
                                                            selectedImage:@"close_down.png"
                                                                   target:self 
                                                                 selector:@selector(menuCloseTapped:)];
        
        CCMenuItemImage *menuChooseLevel = [CCMenuItemImage itemFromNormalImage:@"btn_choose_level_off.png" 
                                                                  selectedImage:@"btn_choose_level_on.png"
                                                                         target:self 
                                                                       selector:@selector(menuChooseLevel:)];
        
        CCMenuItemImage *menuReplay = [CCMenuItemImage itemFromNormalImage:@"btn_replay_off.png" 
                                                             selectedImage:@"btn_replay_on.png"
                                                                    target:self 
                                                                  selector:@selector(menuReplay:)];
        
        
        //close button
        CCMenu *menu; 
        if (inGame)
        {
            menu = [CCMenu menuWithItems:menuChooseLevel, menuReplay, menuClose,nil];
            [menu setPosition:ccp(160,90)];
        }
        else
        {
            menu = [CCMenu menuWithItems:menuClose,nil];
            [menu setPosition:ccp(250,90)];
        }
        
        [menu alignItemsHorizontallyWithPadding:16];
        [self addChild:menu];
        
        [[CCDirector sharedDirector] pause];
    }
    
    return self;
}

- (void)menuCloseTapped:(id)sender {
    [self.parent removeChild:self cleanup:YES];  
    [[CCDirector sharedDirector] resume];
}

- (void)menuChooseLevel:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[ChooseLevelLayer scene]];
}

- (void)menuReplay:(id)sender {
    [[CCDirector sharedDirector] resume];
    
    GameScene *scene = (GameScene *)[[CCDirector sharedDirector] runningScene];
    [[CCDirector sharedDirector] replaceScene:[scene sceneFromCurrent]];
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
            
        case kDebugTag:
            [[[GameObjectCache sharedGameObjectCache] gameLayer] toggleDebug];
            break;
            
        default:
            break;
    };
}
- (void)dealloc{
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

@end
