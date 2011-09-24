//
//  ScoreCard.m
//  greedy
//
//  Created by Richard Owen on 6/07/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "DeathCard.h"
#import "GameScene.h"
#import "MenuScene.h"
#import "SettingsManager.h"


@implementation DeathCard

- (void) createMenu {
  CCSprite *btnChooseLevelOn = [CCSprite spriteWithFile:@"btn_choose_level_on.png"];
  CCSprite *btnChooseLevelOff = [CCSprite spriteWithFile:@"btn_choose_level_off.png"];
  CCMenuItemSprite * btnChooseLevel = [CCMenuItemSprite itemFromNormalSprite:btnChooseLevelOff selectedSprite:btnChooseLevelOn  target:self selector:@selector(gotoMainMenu:)];

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
  CCScene *newScene = [CCTransitionFade transitionWithDuration:1.0f scene:[GameScene sceneWithLevel:1]];
  [[CCDirector sharedDirector] replaceScene:newScene];
}

-(void) gotoMainMenu: (id) sender
{
  [[CCDirector sharedDirector] replaceScene:[MenuScene scene]];
}

- (id)init
{
    self = [super init];
    if (self) {
      
      [self createMenu];

      // load in background
      header = [[CCSprite alloc] initWithFile:@"level_1_header.png"];
      [header setPosition:ccp(160, 430)];
      [self addChild:header];
      
      // load in background
      skull = [[CCSprite alloc] initWithFile:@"death_skull.png"];
      [skull setPosition:ccp(160, 270)];
      [self addChild:skull];
      
      
      // IMPORTANT:
      // The sprite frames will be cached AND RETAINED, and they won't be released unless you call
      //     [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
      //NOTE:
      //The name of your .png and .plist must be the same name
      [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"deathcard.plist"];
      
      //
      // Animation using Sprite Sheet
      //
      //"grossini_dance_01.png" comes from your .plist file
      message = [CCSprite spriteWithSpriteFrameName:@"lose_0.png"]; 
      message.position = ccp(160,170);
      
      CCSpriteBatchNode *spritesheet = [CCSpriteBatchNode batchNodeWithFile:@"deathcard.png"];
      [spritesheet addChild:message];
      [self addChild:spritesheet];
      
      
      NSMutableArray *animFrames = [NSMutableArray array];
      
      
      for(int i = 1; i <= 4; i++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"lose_%d.png",i]];
        [animFrames addObject:frame];
      }
      
      
      
      CCAnimation *animation = [CCAnimation animationWithFrames:animFrames delay:0.5f];
      
      
      // animate the greedy into view
      [message runAction:[CCSequence actions:
                               //[CCFadeOut actionWithDuration:0.25f],
                               //[CCFadeIn actionWithDuration:0.25f],
                               //[CCRotateBy actionWithDuration:2.0f angle:90],
                               [CCDelayTime actionWithDuration:2.0],
                               [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO],
                               [CCCallFuncN actionWithTarget:self selector:@selector(loserLoop)],
                               nil ]];
    }
    
    return self;
}
                                                                                     
- (void) loserLoop
{
  NSMutableArray *animFrames2 = [NSMutableArray array];
  [animFrames2 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"lose_0.png"]];
  [animFrames2 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"lose_4.png"]];
  CCAnimation *animation2 = [CCAnimation animationWithFrames:animFrames2 delay:0.5f];
  
  [message runAction:  [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation2 restoreOriginalFrame:NO]] ];
}

- (void)dealloc
{
  CCLOG(@"Dealloc ScoreCare");
  /*
  [header release];
  [skull release];
  [message release];
  */
  [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
  
  [self removeAllChildrenWithCleanup:YES];
  [super dealloc];
}

@end
