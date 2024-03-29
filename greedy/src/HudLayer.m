//
//  HudLayer.m
//  greedy
//
//  Created by gareth stokes on 7/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "HudLayer.h"
#import "GameConfig.h"
#import "OptionsMenuLayer.h"
#import "GameScene.h"
#import "Greedy.h"
#import "GameObjectCache.h"
#import "SpriteHelperLoader.h"
#import "SettingsManager.h"

@implementation HudLayer

@synthesize lifeMeter = _lifeMeter;
@synthesize CountDown = _countdown;

- (id) init
{
    return [self initWithGameLayer];
}

- (id) initWithGameLayer
{
    NSLog(@"HudLayer: initWithGameLayer");
    
    if (!(self=[super init]))
    {
        return nil;
    }
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    [self setPosition:ccp(0, size.height - 45)];
    [self setContentSize:CGSizeMake(size.width, 45)];
    
    _loader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"hud"];
    [_loader spriteWithUniqueName:@"hud_bg" atPosition:ccp(size.width /2,25) inLayer:self];
  
    // help screens
    int level = [[[GameObjectCache sharedGameObjectCache] gameScene] Level];
    if (level == 1) {
        _helpScreenStatus = @"help_screens_tilt";
        [self schedule:@selector(showHelp:) interval:3];
    }
  
    // background sprite
    CCMenuItemImage *pause = [CCMenuItemImage 
                              itemFromNormalSprite:[_loader spriteWithUniqueName:@"pause_btn_off" atPosition:ccp(0,0) inLayer:nil] 
                              selectedSprite:[_loader spriteWithUniqueName:@"pause_btn_down" atPosition:ccp(0,0) inLayer:nil]
                              target:self 
                              selector:@selector(openSettings:)];
    
    CCMenu *menu = [CCMenu menuWithItems: pause, nil];
    [menu setPosition:CGPointMake(25, 25)];
    [self addChild:menu];
    
    //create life meter
    [self createLifeMeter: size];
    
    //create clock
    _countdown = 99;
    [self createCountdownLabel];
    [self schedule:@selector(updateCountdownClock:) interval:1.0f];
    
    return self;
}


- (void) showHelp:(id)sender
{
    NSLog(@"help status: %@", _helpScreenStatus);
    [[CCDirector sharedDirector] pause];
    if (_helpScreenStatus == @"") 
    {
        [[CCDirector sharedDirector] resume];
        [self unschedule:@selector(showHelp:)];
    }
    
    CCMenuItemImage *tilt = [CCMenuItemImage 
                              itemFromNormalSprite:[_loader spriteWithUniqueName:_helpScreenStatus atPosition:ccp(0,0) inLayer:nil] 
                              selectedSprite:[_loader spriteWithUniqueName:_helpScreenStatus atPosition:ccp(0,0) inLayer:nil]
                              target:self 
                              selector:@selector(unPause:)];
    CCMenu *menu = [CCMenu menuWithItems: tilt, nil];
    [menu setPosition:CGPointMake(160, -180)];
    [menu setTag:kHelpButtonTag];
    [self addChild:menu];
    
    if (_helpScreenStatus == @"help_screens_press") _helpScreenStatus = @"";
    if (_helpScreenStatus == @"help_screens_tilt") _helpScreenStatus = @"help_screens_press";
}

- (void) unPause:(id)sender
{
    [self removeChildByTag:kHelpButtonTag cleanup:YES];
    [[CCDirector sharedDirector] resume];
}

- (void) stop
{
    [self unschedule:@selector(updateCountdownClock:)];
}

- (void) createCountdownLabel {
    CCTexture2DPixelFormat currentFormat = [CCTexture2D defaultAlphaPixelFormat];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    _countdownLabel = [[CCLabelAtlas 
                          labelWithString:@"99" 
                          charMapFile:@"orange_numbers.png" 
                          itemWidth:10 
                          itemHeight:16 
                          startCharMap:'.'] retain];
    [CCTexture2D setDefaultAlphaPixelFormat:currentFormat];	
    [_countdownLabel setPosition:ccp(288,17)];
    [self addChild:_countdownLabel];
}


- (void) updateCountdownClock:(id)sender
{
    if (_countdown == 0)
    {
        CCLOG(@"layer count: %d", [[[GameObjectCache sharedGameObjectCache] gameLayer] retainCount]);      
      [sharedGreedy explode];
        return;
    }
    
    _countdown--;
    [_countdownLabel setString:[NSString stringWithFormat:@"%.2d", _countdown]];
}

- (void) createLifeMeter: (CGSize) size  {
    
    //Create Life Meter art work
    _lifeMeter = [[LifeMeter alloc] initLifeMeter: _loader];
    CCLOG(@"LM retainCount:%d", [_lifeMeter retainCount]);
    _lifeMeter.position = ccp(size.width /2, 25);
    [_lifeMeter setLifeLevel:10];
    
    [[GameObjectCache sharedGameObjectCache] addLifeMeter:_lifeMeter];
    CCLOG(@"LM retainCount:%d", [_lifeMeter retainCount]);
    
    [self addChild:_lifeMeter z:1];
    
    [_lifeMeter release];
    CCLOG(@"LM retainCount:%d", [_lifeMeter retainCount]);
}


- (void)debugGame:(id)sender
{
    [[[GameObjectCache sharedGameObjectCache] gameLayer] toggleDebug];
}

- (void)openSettings:(id)sender
{
    if([[[GameObjectCache sharedGameObjectCache] gameScene] getChildByTag:kOptionsMenu] == nil)
    {
        OptionsMenuLayer *_optionsMenu;
        _optionsMenu = [[[OptionsMenuLayer alloc] init:YES] autorelease];
        _optionsMenu.tag = kOptionsMenu;
        [[[GameObjectCache sharedGameObjectCache] gameScene] addChild:_optionsMenu z:100];
    };
}

- (void) dealloc
{
    NSLog(@"Dealloc HudLayer");
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

@end