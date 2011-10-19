//
//  AsteroidShooter.m
//  greedy
//
//  Created by gareth stokes on 5/10/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "AsteroidShooter.h"
#import "Asteroid.h"
#import "chipmunk.h"

@implementation AsteroidShooter

- (id) initWithEnvironment:(GameEnvironment *)environment position:(CGPoint) pos
{
  if(!(self = [super init])) return nil;
  
  _environment = environment;
  _position = pos;
  
  _total = 7;
  _asteroids = [[NSMutableArray arrayWithCapacity:_total] retain];
  
  for(int i=0; i < _total; i++)
  {
    Asteroid *a = [[[Asteroid alloc] initWithEnvironment:_environment 
                                               withLayer:LAYER_ASTEROID
                                                withSize:4
                                            withPosition:pos] autorelease];
    
    cpShape *shape = [a shape];
    cpBodyApplyImpulse(shape->body, cpv(300000,0), cpv(0,0));
    
    [_asteroids addObject:a];
    [self addChild:a];
  }
  
  _time = 0;
  _swap = 0;
  
  return self;
}


- (void) step:(ccTime)delta
{
  _time += delta;
  
  if ((_time - _swap) > 1)
  {
    int diff = (int)_time % _total;
    NSLog(@"step: %i", diff);
    _swap = _time;
    
    
    Asteroid *a = [_asteroids objectAtIndex:diff];
    
    cpShape *asteroid_shape = [a shape];
    asteroid_shape->body->p = _position;
    cpBodyApplyImpulse(asteroid_shape->body, cpv(300000,0), cpv(0,0));
  }
}

- (void) dealloc
{
  [_asteroids release];
  [super dealloc];
}

@end