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

- (id) init
{
    return [self initWithGameLayer:nil];
}

- (id) initWithGameLayer:(GameLayer*)gameLayer
{
    NSLog(@"HudLayer: initWithGameLayer");
    //if (!(self=[super initWithColor:(ccColor4B){64, 64, 128, 64}]))
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
    
    [self createLifeMeter: size];
    _settingsOpen = NO;
    _countdown = 99;
    [self createCountdownLabel];
    [self schedule:@selector(updateCountdownClock:) interval:1.0f];
    return self;
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
    if (_settingsOpen) return;
    _settingsOpen = YES;
    _optionsMenu = [[[OptionsMenuLayer alloc] init:YES] retain];
        [self.parent addChild:_optionsMenu z:100];
    [_optionsMenu release];
}

- (void) dealloc
{
    NSLog(@"Dealloc HudLayer");
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

@end