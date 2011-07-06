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
      _ScoreLabel = [[CCLabelAtlas labelWithString:@"0000" charMapFile:@"white_score.png" itemWidth:60 itemHeight:120 startCharMap:'.'] retain];
      [CCTexture2D setDefaultAlphaPixelFormat:currentFormat];	
      [_ScoreLabel setScale:0.5];
      [_ScoreLabel setPosition:ccp(35,270)];

}

- (void) createTimeLabel {
  CCTexture2DPixelFormat currentFormat = [CCTexture2D defaultAlphaPixelFormat];
  [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
  _ScoreLabel = [[CCLabelAtlas labelWithString:@"0000" charMapFile:@"time_text.png" itemWidth:60 itemHeight:120 startCharMap:'.'] retain];
  [CCTexture2D setDefaultAlphaPixelFormat:currentFormat];	
  [_ScoreLabel setScale:0.5];
  [_ScoreLabel setPosition:ccp(35,270)];
  
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
  [top_menu  alignItemsHorizontallyWithPadding:66.0f];
  top_menu.position = ccp(84,-64);
  [top_menu setScale:0.5];
  [self addChild:top_menu];
}

-(void) restartLevel: (id) sender
{
  [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
}

- (id)init
{
    self = [super init];
    if (self) {

      
      //CCSprite *test;
      //test = [[CCSprite alloc] initWithFile:@"example.png"];
      //[test setPosition:ccp(160,240)];
      //[test setScale:0.5];
      //[self addChild:test];
      
      
      // load in background
      CCSprite *sprite = [[CCSprite alloc] initWithFile:@"level_1_header.png"];
      [sprite setPosition:ccp(160, 430)];
      [sprite setScale:0.5];
      [self addChild:sprite];
      
      sprite = [[CCSprite alloc] initWithFile:@"gold_bar_empty.png"];
      [sprite setScale:0.5];
      [sprite setPosition:ccp(204.0, 284.0)];
      [self addChild:sprite];
      sprite = [[CCSprite alloc] initWithFile:@"gold_bar_empty.png"];
      [sprite setScale:0.5];
      [sprite setPosition:ccp(230.0, 308.0)];
      [self addChild:sprite];
      sprite = [[CCSprite alloc] initWithFile:@"gold_bar_empty.png"];
      [sprite setScale:0.5];
      [sprite setPosition:ccp(256.0, 332.0)];
      [self addChild:sprite];      
      
      sprite = [[CCSprite alloc] initWithFile:@"time_text.png"];
      [sprite setScale:0.5];
      [sprite setPosition:ccp(132.0, 194.0)];
      [self addChild:sprite];   
      
      sprite = [[CCSprite alloc] initWithFile:@"highscore.png"];
      [sprite setScale:0.5];
      [sprite setPosition:ccp(158.0, 140.0)];
      [self addChild:sprite];       
      
      sprite = [[CCSprite alloc] initWithFile:@"score-dots.png"];
      [sprite setScale:0.5];
      [sprite setPosition:ccp(93.0, 307.0)];
      [self addChild:sprite]; 
      
      _score = 1234;
      [self createScoreLabel];
      [_ScoreLabel setString:[NSString stringWithFormat:@"%d", _score]];
      [self addChild:_ScoreLabel];
      
      [self createMenu];
    }
    
    return self;
}

- (id) initWithScore:(int)score level:(int)level
{
  if([self init] == nil) return nil;
  
  //schedule animation sequence
  
  
  return self;
}

- (void)dealloc
{
  CCLOG(@"Dealloc ScoreCare");
  [_ScoreLabel release];
  [self removeAllChildrenWithCleanup:YES];
  [super dealloc];
}

@end
