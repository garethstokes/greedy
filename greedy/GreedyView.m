//
//  GreedyView.m
//  greedy
//
//  Created by gareth stokes on 1/06/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "GreedyView.h"
#import "cocos2d.h"
#import "chipmunk.h"
#import "SpaceManager.h"
#import "Greedy.h"

@implementation GreedyView
@synthesize thrusting = _thrusting;

- (id) initWithShape:(cpShape *) shape
{
  if(!(self = [super init])) return nil;
  
  _radar = [CCSprite spriteWithFile:@"radio_sweep.png"];
  
  CCSpriteBatchNode* batch = [CCSpriteBatchNode batchNodeWithFile:@"greedy.png" capacity:50]; 
  [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"greedy.plist"];
  
  _sprite = [cpCCSprite spriteWithShape:shape spriteFrameName:@"greedy_open_1.png"];
  [_sprite setScaleX:0.5f];
  [_sprite setScaleY:0.5f];
  
//  NSMutableArray* shake_frames = [NSMutableArray array];
//  [shake_frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_5_offset_b.png"]];
//  
//  CCAnimation *animation = [CCAnimation animationWithFrames:shake_frames delay:0.1f];
//  CCAnimate *action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]] retain];
  
//  [_sprite runAction:[CCRepeatForever actionWithAction: action]];
  
  [batch addChild:_sprite];
  
  _radar.position = ccp(52, 90);
  [_radar setScaleX:0.5f];
  [_radar setScaleY:0.5f];
  [_radar setPosition:[_sprite position]];  
  
  //add radar animation
  id rot1 = [CCRotateBy actionWithDuration: 2 angle:359];  
  [_radar runAction: [CCRepeatForever actionWithAction:rot1]];
  
  //_sprites
  [self addChild:batch];
  [self addChild:_radar];
  
  _thrusting = kGreedyThrustNone;
  _shape = shape;
  
  return self;
} 

- (void) step:(ccTime) delta
{
  [_radar setPosition:[_sprite position]];
}

- (void) updateFeeding:(int)value
{
  NSLog(@"update feeding: %i", value);
  return;
  
  if (value == kGreedyIdle)
  {
    _sprite = [cpCCSprite spriteWithShape:_shape spriteFrameName:@"greedy_open_1.png"];
    [_sprite setScaleX:0.5f];
    [_sprite setScaleY:0.5f];
  }
  
  if (value >= kGreedyEating)
  {
    NSMutableArray* shake_frames = [NSMutableArray array];
    [shake_frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_5_offset_b.png"]];
    
    CCAnimation *animation = [CCAnimation animationWithFrames:shake_frames delay:0.1f];
    CCAnimate *action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]] retain];
    
    [_sprite runAction:[CCRepeatForever actionWithAction: action]];
    return;
  }
}

@end