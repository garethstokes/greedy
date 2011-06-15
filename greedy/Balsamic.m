//
//  Balsamic.m
//  greedy
//
//  Created by gareth stokes on 9/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "Balsamic.h"
#import "cocos2d.h"

@implementation Balsamic

- (id) init
{
  if(!(self = [super init])) return nil;
  
  CCSprite *sprite = [CCSprite spriteWithFile:@"vinegarette.png"];
  [self addChild:sprite];
  
  return self;
}

- (void)dealloc {
  NSLog(@"Dealloc Balsamic");
  [super dealloc];
}

@end
