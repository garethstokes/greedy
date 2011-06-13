//
//  BackgroundAsteroids.m
//  greedy
//
//  Created by gareth stokes on 8/06/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "BackgroundAsteroids.h"
#import "Asteroid.h"

@implementation BackgroundAsteroids

-(id) initWithEnvironment:(GameEnvironment *)environment
{
  if(!(self = [super init])) return nil;
  
  _asteroidField = [[AsteroidField alloc] initWithEnvironment:environment totalArea:(1800 * 500) density:0.25 Layer:LAYER_BACKGROUND];
  [self addChild:_asteroidField];
  
  return self; 
}

-(void) dealloc
{
  [super dealloc];
}

@end
