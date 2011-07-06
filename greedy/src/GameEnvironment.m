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
#import "AsteroidSprite.h"
#import "ConvexHull.h"
#import "GameScene.h"

@implementation GameEnvironment

@synthesize manager=_spaceManager;

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
    
    thisSeg = [_spaceManager addSegmentAtWorldAnchor:cpv(fromX, fromY) 
                             toWorldAnchor:cpv(toX, toY) 
                                      mass:STATIC_MASS 
                                    radius:1.0f];
    
    thisSeg->e = elasticity;
    thisSeg->u  = friction;
  }
  
}

-(void) addTopDownWorldContainmentWithFriction:(cpFloat)friction elasticity:(cpFloat)elasticity height:(cpFloat)height width:(cpFloat)width
{	
  cpFloat WidthHalf = width / 2.0f;
  CGFloat HalfHeight = height / 2.0f;
  
  //bottom
  cpShape *thisSeg;
  thisSeg = [_spaceManager addSegmentAtWorldAnchor:cpv(-WidthHalf, -HalfHeight) 
                                     toWorldAnchor:cpv(WidthHalf, -HalfHeight) 
                                              mass:STATIC_MASS 
                                            radius:1.0f];  
  thisSeg->e = elasticity;
  thisSeg->u  = friction;
  thisSeg->layers = LAYER_OOB;

  //top
  thisSeg = [_spaceManager addSegmentAtWorldAnchor:cpv(-WidthHalf, HalfHeight) 
                                     toWorldAnchor:cpv(WidthHalf, HalfHeight) 
                                              mass:STATIC_MASS 
                                            radius:1.0f];  
  thisSeg->e = elasticity;
  thisSeg->u  = friction;
  thisSeg->layers = LAYER_OOB;
  
  //left
  thisSeg = [_spaceManager addSegmentAtWorldAnchor:cpv(-WidthHalf, -HalfHeight) 
                                     toWorldAnchor:cpv(-WidthHalf, HalfHeight) 
                                              mass:STATIC_MASS 
                                            radius:1.0f];  
  thisSeg->e = elasticity;
  thisSeg->u  = friction;
  thisSeg->layers = LAYER_OOB;
  
  //right
  thisSeg = [_spaceManager addSegmentAtWorldAnchor:cpv(WidthHalf, -HalfHeight) 
                                     toWorldAnchor:cpv(WidthHalf, HalfHeight) 
                                              mass:STATIC_MASS 
                                            radius:1.0f];  
  thisSeg->e = elasticity;
  thisSeg->u  = friction;
  thisSeg->layers = LAYER_OOB;
}

- (BOOL) handleCollisionOutOfBounds:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
  NSLog(@"OUT OF BOUNDS~!!!");
  return YES;
}

- (id) init
{
    if( (self=[super init])) {
      
      //allocate our space manager
      _spaceManager = [[SpaceManagerCocos2d alloc] init];
      [_spaceManager setGravity:ccp(0,0)];
    }
    return self;
}

- (void) dealloc
{
  NSLog(@"Dealloc GameEnvironment");
  [self removeAllChildrenWithCleanup:YES];
  [_spaceManager release];
  [super dealloc];
}

@end
