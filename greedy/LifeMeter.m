//
//  LifeMeter.m
//  greedy
//
//  Created by Richard Owen on 29/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "LifeMeter.h"


@implementation LifeMeter

- (id) initLifeMeter
{
  CCLOG(@"LifeMeter: initLifeMeter");
  
  if(!(self = [super init])) return nil;
  
  // load the sprite sheet
  _lifeMeterBatchNode = [[[CCSpriteBatchNode alloc] initWithFile:@"oranges.png" capacity:11] autorelease];

  //grab the cache singleton
  CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
  
  //Create a holder for the frames
  CCSpriteFrame *frame;
  
  // create the frames
  frame = [[[CCSpriteFrame alloc] initWithTexture:_lifeMeterBatchNode.textureAtlas.texture rect:CGRectMake(0, 0, 0, 0)] retain];
  [cache addSpriteFrame:frame name:@"lifeBar0"];  
  
  for(int i = 1; i <= 10; i++)
  {
    frame = [[[CCSpriteFrame alloc] initWithTexture:_lifeMeterBatchNode.textureAtlas.texture rect:CGRectMake(0, 0, 8 + (i *9), 8)] retain];
    [cache addSpriteFrame:frame name:[NSString stringWithFormat:@"lifeBar%d", i]];
  };
  
  //Set to full bars
  _lifeBars = [[CCSprite spriteWithSpriteFrame:[cache spriteFrameByName:@"lifeBar10"]] retain];
  _lifeBars.position = ccp(0, 0);
  [_lifeBars setAnchorPoint:ccp(0,0)];
  [_lifeMeterBatchNode addChild:_lifeBars];

  // add the sprite batch
  [self addChild:_lifeMeterBatchNode];
  
  //Return the object
  return self;
  
}

- (void) setLifeLevel:(int) level
{  
  //sanity check
  if(level < 0) level = 0;
  if(level > 10) level = 10;
   
    [_lifeBars setDisplayFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"lifeBar%d", level]]];
  
  _lifeBars.position = ccp(-44, -3);
}

-(void) dealloc
{
  NSLog(@"Dealloc LifeMeter");
  [_lifeBars release];
  [_lifeMeterBatchNode release];
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
  [self removeFromParentAndCleanup:YES];
	[super dealloc];
}

@end
