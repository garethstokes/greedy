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
  
  CCSprite *sprite = [CCSprite spriteWithFile:@"bg_stars.png"];
  [self addChild:sprite];
  
  return self;
}

@end
