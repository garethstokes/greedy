//
//  BackgroundAsteroids.m
//  greedy
//
//  Created by gareth stokes on 8/06/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "BackgroundAsteroids.h"
#import "GDKaosEngine.h"
#import "Asteroid.h"

@implementation BackgroundAsteroids

- (id) init
{
  if(!(self = [super init])) return nil;
  
  _environment = [[GameEnvironment alloc] init];
  
  // asteroids.
  GDKaosEngine *engine = [[GDKaosEngine alloc] initWorldSizeCircle:500 withDensity:10.0f];
  
  _asteroids = [[NSMutableArray alloc] init];
  while ([engine hasRoom])
  {
    Asteroid *a = [[Asteroid alloc] initWithEnvironment:_environment 
                                           withPosition:[engine position]];
    [engine addArea:[a area]];
    [self addChild:a];
    [_asteroids addObject:a];
  }
    
  // add circular limits
  [_environment addCircularWorldContainmentWithFriction:0.0 elasticity:0.01f radius:500]; 
  
  //[self schedule: @selector(step:)];
  
  //[self addChild:[_environment.manager createDebugLayer]];
  [_environment.manager start];
  
  return self;
}

@end
