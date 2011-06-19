//
//  Greedy.m
//  greedy
//
//  Created by gareth stokes on 7/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "Greedy.h"
#import "cocos2d.h"
#import "chipmunk.h"
#import "GameConfig.h"
#import "GameScene.h"

@implementation Greedy
@synthesize shape = _shape;

static void
gravityVelocityFunc(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt)
{
	cpBodyUpdateVelocity(body, gravity, damping, dt);
}

- (id) initWith:(GameEnvironment *)environment startPos:(cpVect)startPos
{
  if(!(self = [super init])) return nil;
  
  SpaceManagerCocos2d *manager = [environment manager];
  
  cpShape *shape = [manager 
                    addRectAt:startPos 
                    mass:GREEDYMASS 
                    width:50 
                    height:75 
                    rotation:0];
  
  // set physics
  cpBody *body = shape->body;
  cpBodySetVelLimit(body, 180);
  body->data = self;
  
  _lastPosition = shape->body->p;
  _shape = shape;
  
  // view
  _view = [[GreedyView alloc] initWithShape:shape manager:manager];
  [self addChild:_view];
  return self;
}

- (void)dealloc
{
  NSLog(@"Dealloc Greedy");
  [_view release];
  [self removeAllChildrenWithCleanup:YES];
  [super dealloc];
}

- (void) prestep:(ccTime) delta
{
  cpBodySetAngle(_shape->body, CC_DEGREES_TO_RADIANS(_angle));
  
  if ([_view isThrusting])
  {
    cpVect force = cpvforangle(_shape->body->a);
    force = cpvmult(cpvperp(force), GREEDYTHRUST * delta);
    cpBodyApplyImpulse(_shape->body, force,cpvzero);
  }
  
  //add down force (not a gravity just a "forcy thing")
  cpBodyApplyImpulse(_shape->body, ccp(0, (GREEDYTHRUST/3 * delta) * -1),cpvzero);  
}

- (void) postStep:(ccTime) delta
{
  [_view step:delta];
}

- (void) applyThrust
{
  if ([_view isThrusting]) return;
  NSLog(@"applying thrust...");
  [_view setThrusting:kGreedyThrustLittle];
}

- (void) removeThrust
{
  NSLog(@"removing thrust...");
  [_view setThrusting:kGreedyThrustNone];
}

- (void) setAngle:(cpFloat)value
{
  _angle = value;
}

- (CGPoint) position
{
  cpBody *body = _shape->body;
  return body->p;
}

- (void) setEatingStatusTo:(int) value
{
  if (value == _feeding) return;
  _feeding = value;
  [_view updateFeeding:value];
}

@end