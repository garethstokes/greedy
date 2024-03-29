//
//  GreedyGameEnvironment.m
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "GameEnvironment.h"
#import "cocos2d.h"
#import "chipmunk.h"
#import "SpaceManagerCocos2d.h"
#import "GDKaosEngine.h"
#import "ConvexHull.h"
#import "GameScene.h"
#import "GameObjectCache.h"

@implementation GameEnvironment

-(void) addCircularWorldContainmentWithFriction:(cpFloat)friction elasticity:(cpFloat)elasticity radius:(cpFloat)radius
{	
	int segCount = 16;
  float segAngle = 360.0 / segCount;
  
  cpShape *thisSeg;
  
  for(int seg = 0; seg < segCount; seg++)
  {
    float fromX, fromY = 0.0;
    float toX, toY = 0.0;
    
    fromX = 0 + (radius * cos( CC_DEGREES_TO_RADIANS(seg * segAngle) ) );
    fromY = 0 + (radius * sin( CC_DEGREES_TO_RADIANS(seg * segAngle) ) );
    
    toX = 0.0 + (radius * cos( CC_DEGREES_TO_RADIANS((seg + 1) * segAngle )) );
    toY = 0.0 + (radius * sin( CC_DEGREES_TO_RADIANS((seg + 1) * segAngle) ) );
    
    thisSeg = [sharedSpaceManager addSegmentAtWorldAnchor:cpv(fromX, fromY) 
                                            toWorldAnchor:cpv(toX, toY) 
                                                     mass:STATIC_MASS 
                                                   radius:1.0f];
    
    thisSeg->e = elasticity;
    thisSeg->u  = friction;
  }
  
}

- (void) addOutOfBoundsForAsteroids:(cpFloat)friction elasticity:(cpFloat)elasticity height:(cpFloat)height width:(cpFloat)width
{
  cpFloat WidthHalf = width / 2.0f;
  CGFloat HalfHeight = height / 2.0f;
  
  //bottom
  cpShape *thisSeg;
  thisSeg = [sharedSpaceManager addSegmentAtWorldAnchor:cpv(-WidthHalf, -HalfHeight) 
                                          toWorldAnchor:cpv(WidthHalf, -HalfHeight) 
                                                   mass:STATIC_MASS 
                                                 radius:1.0f];  
  thisSeg->e = 1;
  thisSeg->u  = friction;
  thisSeg->layers = LAYER_ASTEROID_OOB;
  
  //top
  thisSeg = [sharedSpaceManager addSegmentAtWorldAnchor:cpv(-WidthHalf, HalfHeight) 
                                          toWorldAnchor:cpv(WidthHalf, HalfHeight) 
                                                   mass:STATIC_MASS 
                                                 radius:1.0f];  
  thisSeg->e = 1;
  thisSeg->u  = friction;
  thisSeg->layers = LAYER_ASTEROID_OOB;
  
  //left
  thisSeg = [sharedSpaceManager addSegmentAtWorldAnchor:cpv(-WidthHalf, -HalfHeight) 
                                          toWorldAnchor:cpv(-WidthHalf, HalfHeight) 
                                                   mass:STATIC_MASS 
                                                 radius:1.0f];  
  thisSeg->e = 1;
  thisSeg->u  = friction;
  thisSeg->layers = LAYER_ASTEROID_OOB;
  
  //right
  thisSeg = [sharedSpaceManager addSegmentAtWorldAnchor:cpv(WidthHalf, -HalfHeight) 
                                          toWorldAnchor:cpv(WidthHalf, HalfHeight) 
                                                   mass:STATIC_MASS 
                                                 radius:1.0f];  
  thisSeg->e = 1;
  thisSeg->u  = friction;
  thisSeg->layers = LAYER_ASTEROID_OOB;
}

-(void) addTopDownWorldContainmentWithFriction:(cpFloat)friction elasticity:(cpFloat)elasticity height:(cpFloat)height width:(cpFloat)width
{	
  cpFloat WidthHalf = width / 2.0f;
  CGFloat HalfHeight = height / 2.0f;
  
  //bottom
  cpShape *thisSeg;
  thisSeg = [sharedSpaceManager addSegmentAtWorldAnchor:cpv(-WidthHalf, -HalfHeight) 
                                          toWorldAnchor:cpv(WidthHalf, -HalfHeight) 
                                                   mass:STATIC_MASS 
                                                 radius:1.0f];  
  thisSeg->e = elasticity;
  thisSeg->u  = friction;
  thisSeg->layers = LAYER_OOB;
  
  //top
  thisSeg = [sharedSpaceManager addSegmentAtWorldAnchor:cpv(-WidthHalf, HalfHeight) 
                                          toWorldAnchor:cpv(WidthHalf, HalfHeight) 
                                                   mass:STATIC_MASS 
                                                 radius:1.0f];  
  thisSeg->e = elasticity;
  thisSeg->u  = friction;
  thisSeg->layers = LAYER_OOB;
  
  //left
  thisSeg = [sharedSpaceManager addSegmentAtWorldAnchor:cpv(-WidthHalf, -HalfHeight) 
                                          toWorldAnchor:cpv(-WidthHalf, HalfHeight) 
                                                   mass:STATIC_MASS 
                                                 radius:1.0f];  
  thisSeg->e = elasticity;
  thisSeg->u  = friction;
  thisSeg->layers = LAYER_OOB;
  
  //right
  thisSeg = [sharedSpaceManager addSegmentAtWorldAnchor:cpv(WidthHalf, -HalfHeight) 
                                          toWorldAnchor:cpv(WidthHalf, HalfHeight) 
                                                   mass:STATIC_MASS 
                                                 radius:1.0f];  
  thisSeg->e = elasticity;
  thisSeg->u  = friction;
  thisSeg->layers = LAYER_OOB;
  
  [self addOutOfBoundsForAsteroids:friction elasticity:elasticity height:(height + 400) width:(width + 200)];
}

- (BOOL) handleCollisionOutOfBounds:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
  NSLog(@"OUT OF BOUNDS~!!!");
  return YES;
}

- (id) init
{
  CCLOG(@"GameEnvironment: init");
  
  if( (self=[super init])) {
    
    //allocate our space manager
    SpaceManagerCocos2d * aManager = [[SpaceManagerCocos2d alloc] init];
    [[GameObjectCache sharedGameObjectCache] addSpaceManager:aManager];
    [aManager setGravity:ccp(0,0)];
    [aManager release];
  }
  return self;
}

- (void) dealloc
{
  NSLog(@"Dealloc GameEnvironment");
  
  CCLOG(@"Shared Space Manager 4: %d", [sharedSpaceManager retainCount]);
  
  [self removeAllChildrenWithCleanup:YES];
  
  [super dealloc];
}

@end
