//
//  ScoreCard.m
//  greedy
//
//  Created by Richard Owen on 6/07/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "ScoreCard.h"
#import "GameScene.h"


@implementation ScoreCard

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
  CCMenuItemSprite * btnChooseLevel = [CCMenuItemSprite itemFromNormalSprite:btnChooseLevelOff selectedSprite:btnChooseLevelOn];

  CCSprite *btnReplayOn = [CCSprite spriteWithFile:@"btn_replay_on.png"];
  CCSprite *btnReplayOff = [CCSprite spriteWithFile:@"btn_replay_off.png"];
  CCMenuItemSprite * btnReplay = [CCMenuItemSprite itemFromNormalSprite:btnReplayOff selectedSprite:btnReplayOn target:self selector:@selector(restartLevel:)];
  
  CCSprite *btnSkipOn = [CCSprite spriteWithFile:@"btn_skip_on.png"];
  CCSprite *btnSkipOff = [CCSprite spriteWithFile:@"btn_skip_off.png"];
  CCMenuItemSprite * btnSkip = [CCMenuItemSprite itemFromNormalSprite:btnSkipOff selectedSprite:btnSkipOn];
  
  CCMenu *top_menu = [CCMenu menuWithItems:btnChooseLevel, btnReplay, btnSkip, nil];
  [top_menu  alignItemsHorizontallyWithPadding:32.0];
  top_menu.position = ccp(160,56);
  [self addChild:top_menu];
}

-(void) restartLevel: (id) sender
{
  [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
}

- (void) showBars {
  CCSprite *sprite;
  sprite = [[CCSprite alloc] initWithFile:@"gold_bar_empty.png"];
  [sprite setPosition:ccp(204.0, 284.0)];
  [self addChild:sprite];
  sprite = [[CCSprite alloc] initWithFile:@"gold_bar_empty.png"];
  [sprite setPosition:ccp(230.0, 308.0)];
  [self addChild:sprite];
  sprite = [[CCSprite alloc] initWithFile:@"gold_bar_empty.png"];
  [sprite setPosition:ccp(256.0, 332.0)];
  [self addChild:sprite];
}

- (void) showHighScore {
  CCSprite *sprite;
  sprite = [[CCSprite alloc] initWithFile:@"highscore.png"];
  [sprite setPosition:ccp(158.0, 140.0)];
  [self addChild:sprite];
}

- (void) showExample:(BOOL) flag {
  if(flag)
  {
    CCSprite *test;
    test = [[CCSprite alloc] initWithFile:@"example.png"];
    [test setScale:0.5];
    [test setPosition:ccp(160,240)];
    [self addChild:test];
  }
}

- (void) showScore {
  [self createScoreLabel];
  [_ScoreLabel setString:[NSString stringWithFormat:@"%d", _score]];
  [self addChild:_ScoreLabel];
}
- (void) showTimeLeft {
  [self createTimeLabel];
  [_TimeLabel setString:[NSString stringWithFormat:@"%#.2f", _timeleft]];
  [self addChild:_TimeLabel];
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
      
      sprite = [[CCSprite alloc] initWithFile:@"time_text.png"];
      [sprite setPosition:ccp(132.0, 194.0)];
      [self addChild:sprite];   

      sprite = [[CCSprite alloc] initWithFile:@"score-dots.png"];
      [sprite setPosition:ccp(93.0, 307.0)];
      [self addChild:sprite]; 
      
    }
    
    return self;
}

- (id) initWithScore:(int)score level:(int)level time:(ccTime)time
{
  if([self init] == nil) return nil;
  
  _level = level;
  
  _score = score;
  
  _timeleft = time;
  
  [self showBars];
  
  [self showHighScore];
  
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
