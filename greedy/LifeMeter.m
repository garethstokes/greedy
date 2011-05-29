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
  _lifeMeterBatchNode = [[CCSpriteBatchNode alloc] initWithFile:@"life_bar_sprite.png" capacity:11];

  //grab the cache singleton
  CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
  
  //Create a holder for the frames
  CCSpriteFrame *frame;
  
  //Create the background grid
  frame = [[CCSpriteFrame alloc] initWithTexture:_lifeMeterBatchNode.textureAtlas.texture rect:CGRectMake(0, 0, 195, 21)];
  [cache addSpriteFrame:frame name:@"lifeMeterGrid"];
  

  // create the frames
  for(int i = 0; i < 10; i++)
  {
    frame = [[CCSpriteFrame alloc] initWithTexture:_lifeMeterBatchNode.textureAtlas.texture rect:CGRectMake(4, 24, 16 + (i * 19), 15)];
    [cache addSpriteFrame:frame name:[NSString stringWithFormat:@"lifeBar%d", i + 1]];
  };
  
  //Set to full bars
  _lifeBars = [[CCSprite spriteWithSpriteFrame:[cache spriteFrameByName:@"lifeBar1"]] retain];
  _lifeBars.position = ccp(_lifeBars.contentSizeInPixels.width / 2 + 4, _lifeBars.contentSizeInPixels.height / 2 + 3);
  [_lifeMeterBatchNode addChild:_lifeBars];

  // add the sprite batch
  [self initWithSpriteFrameName:@"lifeMeterGrid"];
  [self addChild:_lifeMeterBatchNode];
  
  //Return the object
  return self;
  
}

- (void) setLifeLevel:(int) level
{  
  [_lifeBars setDisplayFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"lifeBar%d", level]]];
  
  _lifeBars.position = ccp(_lifeBars.contentSizeInPixels.width / 2 + 4, _lifeBars.contentSizeInPixels.height / 2 + 3);
  
}

-(void) dealloc
{
  [_lifeBars release];
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[super dealloc];
}

@end
