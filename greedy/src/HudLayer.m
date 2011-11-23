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
    
    // background sprite
    CCSprite *background = [CCSprite spriteWithFile:@"hud_bg.png"];
    [background setPosition:ccp(size.width /2,25)];
    [self addChild:background z:-1];
    
    CCMenuItemImage *pause = [CCMenuItemImage itemFromNormalImage:@"pause_btn_off.png" 
                                                    selectedImage:@"pause_btn_down.png" 
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

- (void) stop
{
    [self unschedule:@selector(updateCountdownClock:)];
}

- (void) createCountdownLabel {
    CCTexture2DPixelFormat currentFormat = [CCTexture2D defaultAlphaPixelFormat];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    _countdownLabel = [[CCLabelAtlas labelWithString:@"99" charMapFile:@"orange_numbers.png" itemWidth:10 itemHeight:16 startCharMap:'.'] retain];
    [CCTexture2D setDefaultAlphaPixelFormat:currentFormat];	
    [_countdownLabel setPosition:ccp(288,17)];
    [self addChild:_countdownLabel];
}


- (void) updateCountdownClock:(id)sender
{
    if (_countdown == 0)
    {
        CCLOG(@"layer count: %d", [[[GameObjectCache sharedGameObjectCache] gameLayer] retainCount]);
        GameLayer *layer = [[GameObjectCache sharedGameObjectCache] gameLayer];
        Greedy *greedy = [layer greedy];
        [greedy explode];
        return;
    }
    
    _countdown--;
    [_countdownLabel setString:[NSString stringWithFormat:@"%.2d", _countdown]];
}

- (void) createLifeMeter: (CGSize) size  {
    
    //Create Life Meter art work
    _lifeMeter = [[LifeMeter alloc] initLifeMeter];
    CCLOG(@"LM retainCount:%d", [_lifeMeter retainCount]);
    _lifeMeter.position = ccp(size.width /2, 25);
    [_lifeMeter setLifeLevel:10];
    
    [[GameObjectCache sharedGameObjectCache] addLifeMeter:_lifeMeter];
    CCLOG(@"LM retainCount:%d", [_lifeMeter retainCount]);
    
    [self addChild:_lifeMeter];
    
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

<<<<<<< HEAD
        _optionsMenu = [[[OptionsMenuLayer alloc] init:YES] retain];
        _optionsMenu.tag = kOptionsMenu;
            [[[GameObjectCache sharedGameObjectCache] gameScene] addChild:_optionsMenu z:100];
        [_optionsMenu release];
=======
        _optionsMenu = [[[OptionsMenuLayer alloc] init:YES] autorelease];
        _optionsMenu.tag = kOptionsMenu;
        [[[GameObjectCache sharedGameObjectCache] gameScene] addChild:_optionsMenu z:100];
>>>>>>> - Added greedy back in
    };
}

- (void) dealloc
{
    NSLog(@"Dealloc HudLayer");
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

@end