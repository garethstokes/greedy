//
//  Level.m
//  greedy
//
//  Created by Gareth Stokes on 20/07/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "GreedyLevel.h"

@implementation ShooterConfig
@synthesize rotation=_rotation;
@synthesize position=_position;

- (void) importFromDictionary:(NSDictionary *)dictionary
{
  _rotation = [[dictionary objectForKey: @"rotation"] intValue];
  
  float x = [[dictionary objectForKey: @"x"] floatValue];
  float y = [[dictionary objectForKey: @"y"] floatValue];
  _position = CGPointMake(x,y);
}

@end

@implementation StaticAsteroidsConfig
@synthesize size = _size;
@synthesize position = _position;

- (void) importFromDictionary:(NSDictionary *)dictionary 
{
  _size = [[dictionary objectForKey: @"size"] intValue];
  
  float x = [[dictionary objectForKey: @"x"] floatValue];
  float y = [[dictionary objectForKey: @"y"] floatValue];
  _position = CGPointMake(x,y);
  
}

@end

@implementation EnvironmentConfig
@synthesize width;
@synthesize height;
@synthesize friction;
@synthesize elasticity;
    
- (void) importFromDictionary:(NSDictionary *)dictionary
{
  self.width = [[dictionary objectForKey: @"width"] intValue];
  self.height = [[dictionary objectForKey: @"height"] intValue]; 
  self.friction = [[dictionary objectForKey: @"friction"] intValue];
  self.elasticity = [[dictionary objectForKey: @"elasticity"] intValue];
}

@end

@implementation GreedyLevel

@synthesize number                = _number;
@synthesize asteroidFieldHeight   = _asteroidFieldHeight;
@synthesize asteroidFieldWidth    = _asteroidFieldWidth;
@synthesize staticAsteroids       = _staticAsteroids;
@synthesize greedyPosition        = _greedyPosition;
@synthesize environment           = _environment;
@synthesize startPosition         = _startPosition;
@synthesize finishPosition        = _finishPosition;
@synthesize shooters              = _shooters;

- (id)init
{
    NSLog(@" GameLevel: init");
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) importFromDictionary:(NSDictionary *)dictionary
{
  NSDictionary *asteroidField = [dictionary valueForKey: @"AsteroidField"];
  _asteroidFieldWidth = [[asteroidField objectForKey: @"width"] intValue];
  _asteroidFieldHeight = [[asteroidField objectForKey: @"height"] intValue];
 
  //Load in Static objects
  NSArray *asteroids = [dictionary valueForKey:@"StaticAsteroids"];
  _staticAsteroids = [NSMutableArray array];
  for (int i = 0; i < [asteroids count]; i++)
  {
    StaticAsteroidsConfig *a = [[[StaticAsteroidsConfig alloc] init] autorelease];
    NSDictionary *config = [asteroids objectAtIndex:i];
    [a importFromDictionary:config];
    [_staticAsteroids addObject:a];
  }
  
  //shooters
  NSArray *shooters = [dictionary valueForKey:@"AsteroidShooters"];
  _shooters = [NSMutableArray array];
  for (int i = 0; i < [shooters count]; i++)
  {
    id a = [[[ShooterConfig alloc] init] autorelease];
    NSDictionary *config = [shooters objectAtIndex:i];
    [a importFromDictionary:config];
    [_shooters addObject:a];
  }  
  
  NSDictionary *startPosition = [dictionary valueForKey: @"StartPosition"];
  _greedyPosition = CGPointMake([[startPosition objectForKey: @"x"] floatValue],[[startPosition objectForKey: @"y"] floatValue]);
  
  NSDictionary *environment = [dictionary valueForKey: @"Environment"];
  _environment = [[EnvironmentConfig alloc] init];
  [_environment importFromDictionary:environment];
  
  NSDictionary *startLine = [dictionary valueForKey: @"StartLine"];
  _startPosition = CGPointMake([[startLine objectForKey: @"x"] floatValue],[[startLine objectForKey: @"y"] floatValue]);
  
  NSDictionary *endPosition = [dictionary valueForKey: @"EndPosition"];
  _finishPosition = CGPointMake([[endPosition objectForKey: @"x"] floatValue],[[endPosition objectForKey: @"y"] floatValue]);
}

@end
