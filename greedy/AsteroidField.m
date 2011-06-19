//
//  AsteroidField.m
//  greedy
//
//  Created by Richard Owen on 13/06/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "AsteroidField.h"
#import "Asteroid.h"
#import "GDKaosEngine.h"

@implementation AsteroidField
@synthesize asteroids = _asteroids;

- (id) initWithEnvironment:(GameEnvironment *)environment totalArea:(float)totalArea density:(float)density Layer:(cpLayers)Layer
{
  if((self=[super init])){
    
    _asteroids = [[NSMutableArray alloc] init];
    
    GDKaosEngine *engine = [[GDKaosEngine alloc] initWorldSize:CGSizeMake(500.0, 1800.0) withDensity:density];
    
    while ([engine hasRoom])
    {
      Asteroid *a = [[[Asteroid alloc] initWithEnvironment:environment 
                                              withPosition:[engine position]
                                                withLayer:Layer] autorelease];
      [engine addArea:[a area]];
      
      [_asteroids addObject:a];
      [a release];
      
      [self addChild:a];
    }
    
    [engine release];
  };
  
  return self;
}

- (void)dealloc
{
  NSLog(@"Dealloc AsteroidField");
  [self removeAllChildrenWithCleanup:YES];
  [_asteroids removeAllObjects];
  [super dealloc];
}

@end
