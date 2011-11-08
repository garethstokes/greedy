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

- (id) initWithAsteroidField:(AsteroidField *)field position:(CGPoint) pos
{
    if(!(self = [super init])) return nil;
    
    _position = pos;
    
    _total = 7;
    _asteroids = [[NSMutableArray arrayWithCapacity:_total] retain];
    
    for(int i=0; i < _total; i++)
    {
        Asteroid *a = [field addAsteroid:pos size:4 ];
        
        cpShape *shape = [a shape];
        cpBodyApplyImpulse(shape->body, cpv(300000,0), cpv(0,0));
        
        [_asteroids addObject:a];
        //[self addChild:a];
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
        [a resetForces];
        cpBodyApplyImpulse(asteroid_shape->body, cpv(300000,0), cpv(0,0));
    }
}

- (void) dealloc
{
    [_asteroids release];
    [super dealloc];
}

@end