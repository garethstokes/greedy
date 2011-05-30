//
//  Background.m
//  greedy
//
//  Created by gareth stokes on 8/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "Background.h"
#import "cocos2d.h"

@implementation Background

- (id) init
{
  if(!(self = [super init])) return nil;
  
  CCSprite *stars = [CCSprite spriteWithFile:@"bg_stars.png"];
  CCSprite *nebula = [CCSprite spriteWithFile:@"nebula.png"];

  
  //[self addChild:sprite];
  // create a void node, a parent node
  _parallax = [CCParallaxNode node];
  
  // background image is moved at a ratio of 0.4x, 0.5y
  [_parallax addChild:stars z:-1 parallaxRatio:ccp(0.05f,0.1f) positionOffset:CGPointZero];
  [_parallax addChild:nebula z:2 parallaxRatio:ccp(0.09f,0.15f) positionOffset:ccp(0, 200)];
  
  [self addChild:_parallax z:0];
  
  return self;
}

- (void) step
{

}

- (void) setPosition:(CGPoint)position
{
  [_parallax setPosition:position];
  [super setPosition:position];
}

@end
