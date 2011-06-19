//
//  Asteroid.m
//  greedy
//
//  Created by gareth stokes on 8/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "Asteroid.h"
#import "ConvexHull.h"
#import "AsteroidSprite.h"
#import "chipmunk.h"

@implementation Asteroid

- (id) initWithEnvironment:(GameEnvironment *)environment withPosition:(cpVect)position withLayer:(cpLayers)withLayer
{
  if(!(self = [super init])) return nil;

  _convexHull = [[[ConvexHull alloc] initWithStaticSize:arc4random() % 10]autorelease];
  _mass = (int)[_convexHull area];
  
  _shape = [environment.manager 
                       addPolyAt:position
                       mass:_mass 
                       rotation:CCRANDOM_0_1()
                       points:[_convexHull points]];
  
  _shape->layers = withLayer;
  
  // push it in a random direction.
  if(withLayer != LAYER_BACKGROUND)
  {
    CGPoint p = rand() % 2 == 0 ? ccp(CCRANDOM_0_1(),CCRANDOM_0_1()) : ccpNeg(ccp(CCRANDOM_0_1(),CCRANDOM_0_1()));
    cpBodyApplyImpulse(_shape->body, 
                     p, 
                     ccp(rand() % 10000, rand() % 10000));
  }else{
    cpBodySleep(_shape->body);
  };
  
  cpCCSprite *sprite = [[AsteroidSprite alloc] initWithPoints:[_convexHull points] 
                                                         size:[_convexHull size] 
                                                    withShape:_shape];
  
  [self addChild:sprite];
  [sprite release];
  
  return self;
}

- (CGPoint) position
{
  cpBody *body = _shape->body;
  return body->p;
}

- (void)dealloc
{
  NSLog(@"Dealloc Asteroid");
  [self removeAllChildrenWithCleanup:YES];
  [super dealloc];
}

- (cpFloat) area { return [_convexHull area]; }
- (int) mass { return _mass; }

@end
