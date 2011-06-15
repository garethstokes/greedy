//
//  Background.m
//  greedy
//
//  Created by gareth stokes on 8/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "Background.h"
#import "cocos2d.h"
#import "BackgroundAsteroids.h"

@implementation Background

- (id) initWithEnvironment:(GameEnvironment *)environment
{
  if(!(self = [super init])) return nil;
  
  //[self addChild:sprite];
  // create a void node, a parent node
  _parallax = [CCParallaxNode node];
  
  CCSprite *stars = [CCSprite spriteWithFile:@"bg_stars.png"];
  CCSprite *nebula = [CCSprite spriteWithFile:@"nebula.png"];
  BackgroundAsteroids *background = [[[BackgroundAsteroids alloc] initWithEnvironment:environment] autorelease];

  // background image is moved at a ratio of 0.4x, 0.5y
  [_parallax addChild:stars z:-1 parallaxRatio:ccp(0.05f,0.1f) positionOffset:CGPointZero];
  [_parallax addChild:nebula z:2 parallaxRatio:ccp(0.09f,0.15f) positionOffset:ccp(0, 200)];
  [_parallax addChild:background z:3 parallaxRatio:ccp(0.05f,0.4f) positionOffset:CGPointZero];
  
  [self addChild:_parallax z:0];
  
  return self;
}

- (void) setPosition:(CGPoint)position
{
  [_parallax setPosition:position];
  [super setPosition:position];
}

-(void) dealloc
{
  NSLog(@"Dealloc Background");
  [super dealloc];
}

@end
