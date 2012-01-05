//
//  ScoreCard.m
//  greedy
//
//  Created by Richard Owen on 6/07/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "ScoreCard.h"
#import "GameScene.h"
#import "SettingsManager.h"
#import "MainMenuLayer.h"
#import "GameObjectCache.h"


@implementation ScoreCard

@synthesize time = _timeleft;
@synthesize score = _score;


- (void) setTime:(int)time {
    _timeleft = time;
    
    [_TimeLabel setString:[NSString stringWithFormat:@"%d", _timeleft]];
    
    CCLOG(@"Time set in score card: %d", time);
}

- (void) setScore:(int)score {
    _score = score;
    
    [_ScoreLabel setString:[NSString stringWithFormat:@"%d", _score]];
    
    CCLOG(@"Score set in score card: %d", score);
}

- (void) createScoreLabel {
    CCTexture2DPixelFormat currentFormat = [CCTexture2D defaultAlphaPixelFormat];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    _ScoreLabel = [[CCLabelAtlas labelWithString:@"0000" charMapFile:@"white_score.png" itemWidth:30 itemHeight:37 startCharMap:'.'] retain];
    [CCTexture2D setDefaultAlphaPixelFormat:currentFormat];	
    [_ScoreLabel setPosition:ccp(35,289)];
}

- (void) createTimeLabel {
    CCTexture2DPixelFormat currentFormat = [CCTexture2D defaultAlphaPixelFormat];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    _TimeLabel = [[CCLabelAtlas labelWithString:@"123456.78" charMapFile:@"orange_numbers.png" itemWidth:10 itemHeight:16 startCharMap:'.'] retain];
    [CCTexture2D setDefaultAlphaPixelFormat:currentFormat];	
    [_TimeLabel setPosition:ccp(170,186)];
}

- (void) createMenu {
    CCSprite *btnChooseLevelOn = [CCSprite spriteWithFile:@"btn_choose_level_on.png"];
    CCSprite *btnChooseLevelOff = [CCSprite spriteWithFile:@"btn_choose_level_off.png"];
    CCMenuItemSprite * btnChooseLevel = [CCMenuItemSprite itemFromNormalSprite:btnChooseLevelOff selectedSprite:btnChooseLevelOn  target:self selector:@selector(gotoMainMenu:)];
    
    CCSprite *btnReplayOn = [CCSprite spriteWithFile:@"btn_replay_on.png"];
    CCSprite *btnReplayOff = [CCSprite spriteWithFile:@"btn_replay_off.png"];
    CCMenuItemSprite * btnReplay = [CCMenuItemSprite itemFromNormalSprite:btnReplayOff selectedSprite:btnReplayOn target:self selector:@selector(restartLevel:)];
    
    CCMenu *top_menu = [CCMenu menuWithItems:btnChooseLevel, btnReplay, nil];
    
    GameScene *scene = (GameScene *)[[CCDirector sharedDirector] runningScene];
    int lev = [scene Level];
    if (lev < MAX_LEVEL)
    {
        CCSprite *btnSkipOn = [CCSprite spriteWithFile:@"btn_skip_on.png"];
        CCSprite *btnSkipOff = [CCSprite spriteWithFile:@"btn_skip_off.png"];
        
        CCMenuItemSprite * btnSkip = [CCMenuItemSprite itemFromNormalSprite:btnSkipOff selectedSprite:btnSkipOn target:self selector:@selector(nextLevel:)];
        [top_menu addChild:btnSkip];
    }

    [top_menu  alignItemsHorizontallyWithPadding:32.0];
    top_menu.position = ccp(160,56);
    [self addChild:top_menu];
}

-(void) restartLevel: (id) sender
{
    CCScene *newScene = [CCTransitionFade transitionWithDuration:1.0f scene:[[[GameObjectCache sharedGameObjectCache] gameScene] sceneFromCurrent]];
    [[CCDirector sharedDirector] replaceScene:newScene];
}

-(void) nextLevel: (id) sender
{
    CCScene *newScene = [CCTransitionFade transitionWithDuration:1.0f scene:[GameScene sceneWithLevel:[[[GameObjectCache sharedGameObjectCache] gameScene] Level] + 1]];
    [[CCDirector sharedDirector] replaceScene:newScene];
}

-(void) gotoMainMenu: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0f scene:[MainMenuLayer scene]]];
}

- (void) showBars:(int)score {
    NSString* full = @"gold_bar_full.png";
    NSString* empty = @"gold_bar_empty.png";
    
    CCSprite *sprite;
    
    NSString* markerKey = [NSString stringWithFormat:@"gold_for_level_%i_%i", _level, 1];
    int marker = [[SettingsManager sharedSettingsManager] getInt:markerKey withDefault:0];
    
    sprite = [[CCSprite alloc] initWithFile:score > marker ? full : empty];
    [sprite setPosition:ccp(204.0, 284.0)];
    [self addChild:sprite];
    [sprite release];
    
    markerKey = [NSString stringWithFormat:@"gold_for_level_%i_%i", _level, 2];
    marker = [[SettingsManager sharedSettingsManager] getInt:markerKey withDefault:0];
    sprite = [[CCSprite alloc] initWithFile:score > marker ? full : empty];
    [sprite setPosition:ccp(230.0, 308.0)];
    [self addChild:sprite];
    [sprite release];
    
    markerKey = [NSString stringWithFormat:@"gold_for_level_%i_%i", _level, 3];
    marker = [[SettingsManager sharedSettingsManager] getInt:markerKey withDefault:0];
    sprite = [[CCSprite alloc] initWithFile:score > marker ? full : empty];
    [sprite setPosition:ccp(256.0, 332.0)];
    [self addChild:sprite];
    [sprite release];
}

- (void) showHighScore {
    CCSprite *sprite;
    sprite = [[CCSprite alloc] initWithFile:@"highscore.png"];
    [sprite setPosition:ccp(158.0, 140.0)];
    [self addChild:sprite];
    [sprite release];
}

- (void) showExample:(BOOL) flag {
    if(flag)
    {
        CCSprite *test;
        test = [[CCSprite alloc] initWithFile:@"example.png"];
        [test setScale:0.5];
        [test setPosition:ccp(160,240)];
        [self addChild:test];
        [test release];
    }
}

- (void) showScore {
    [self createScoreLabel];
    [_ScoreLabel setString:[NSString stringWithFormat:@"%d", _score]];
    [self addChild:_ScoreLabel];
}

- (void) showTimeLeft {
    [self createTimeLabel];
    [_TimeLabel setString:[NSString stringWithFormat:@"%d", _timeleft]];
    [self addChild:_TimeLabel];
    
    id modifyTime = [CCActionTween actionWithDuration:2 key:@"time" from:_timeleft to:0];
    id modifyScore = [CCActionTween actionWithDuration:2 key:@"score" from:_score to:(_score + (_timeleft * 100))];
	[self runAction:[CCSpawn actions:modifyTime, modifyScore, nil]];
}



- (id)init
{
    self = [super init];
    if (self) {
        
        [self showExample:false];
        
        // load in background
        CCSprite *sprite = [[CCSprite alloc] initWithFile:@"level_1_header.png"];
        [sprite setPosition:ccp(160, 430)];
        [self addChild:sprite];
        [sprite release];
        
        sprite = [[CCSprite alloc] initWithFile:@"time_text.png"];
        [sprite setPosition:ccp(132.0, 194.0)];
        [self addChild:sprite]; 
        [sprite release];
        
        sprite = [[CCSprite alloc] initWithFile:@"score-dots.png"];
        [sprite setPosition:ccp(93.0, 307.0)];
        [self addChild:sprite];
        [sprite release];
        
        //[self showHighScore];
    }
    
    return self;
}

- (id) initWithScore:(int)score level:(int)level time:(int)time
{
    if((self = [self init]) == nil) return nil;
    
    _level = level;
    
    _score = score;
    
    _timeleft = time;
    
    [self showBars:score];
    
    int currentLevel = [[SettingsManager sharedSettingsManager] getInt:@"current_level" withDefault:1];
    if (level == currentLevel && level < MAX_LEVEL)
    {
        [[SettingsManager sharedSettingsManager] setValue:@"current_level" newInt:level +1];
    }
    
    int prevHighScore = [[SettingsManager sharedSettingsManager] getInt:[NSString stringWithFormat:@"high_score_%i", level] withDefault:0]; 
    if(score > prevHighScore)
    {
        [self showHighScore];
        [[SettingsManager sharedSettingsManager] setValue:[NSString stringWithFormat:@"high_score_%i", level] newInt:score];
    }
    
    [self showScore];
    
    [self showTimeLeft];
    
    [self createMenu];
    
    return self;
}

- (void)dealloc
{
    CCLOG(@"Dealloc ScoreCare");
    [_ScoreLabel release];
    [_TimeLabel release];
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

@end
