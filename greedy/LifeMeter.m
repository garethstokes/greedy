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
  if(!(self = [super init])) return nil;
  
  // load the sprite sheet
  _lifeMeterBatchNode = [[[CCSpriteBatchNode alloc] initWithFile:@"life_bar_sprite.png" capacity:11] autorelease];

  //grab the cache singleton
  CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
  
  //Create a holder for the frames
  CCSpriteFrame *frame;
  
  //Create the background grid
  frame = [[[CCSpriteFrame alloc] initWithTexture:_lifeMeterBatchNode.textureAtlas.texture rect:CGRectMake(0, 0, 98, 11)] autorelease];
  [cache addSpriteFrame:frame name:@"lifeMeterGrid"];
  

  // create the frames

  frame = [[[CCSpriteFrame alloc] initWithTexture:_lifeMeterBatchNode.textureAtlas.texture rect:CGRectMake(2, 12, 0, 0)] autorelease];
  [cache addSpriteFrame:frame name:@"lifeBar0"];  
  
  for(int i = 1; i <= 10; i++)
  {
    frame = [[[CCSpriteFrame alloc] initWithTexture:_lifeMeterBatchNode.textureAtlas.texture rect:CGRectMake(2, 12, 8 + (i * 9), 8)] autorelease];
    [cache addSpriteFrame:frame name:[NSString stringWithFormat:@"lifeBar%d", i]];
  };
  
  //Set to full bars
  _lifeBars = [[CCSprite spriteWithSpriteFrame:[cache spriteFrameByName:@"lifeBar10"]] retain];
  _lifeBars.position = ccp(_lifeBars.contentSize.width / 2 + 2, _lifeBars.contentSize.height / 2);
  [_lifeMeterBatchNode addChild:_lifeBars];

  // add the sprite batch
  [self initWithSpriteFrameName:@"lifeMeterGrid"];
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
  
  _lifeBars.position = ccp(_lifeBars.contentSize.width / 2 + 2, _lifeBars.contentSize.height / 2);
  
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
