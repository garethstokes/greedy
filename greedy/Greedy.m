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
#import "SpaceManager.h"
#import "GameConfig.h"

@implementation Greedy
@synthesize shape = _shape;
@synthesize radar = _radar;
@synthesize asteroids = _asteroids;

#define GREEDYMASS    2000.0f
#define GREEDYTHRUST  100000
#define GREEDYTHRUSTPERSECOND (10000 / 60)

static void
gravityVelocityFunc(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt)
{
	cpBodyUpdateVelocity(body, gravity, damping, dt);
}

- (id) initWith:(GameEnvironment *)environment
{
  if(!(self = [super init])) return nil;
  
  SpaceManagerCocos2d *manager = [environment manager];
  cpShape *shape = [manager 
                    addRectAt:ccp(100,200) 
                    mass:GREEDYMASS 
                    width:50 
                    height:75 
                    rotation:0];
  
  cpCCSprite *sprite = [cpCCSprite 
                            spriteWithShape:shape 
                            file:@"greedy_open_5.png"];
  
  _radar = [CCSprite spriteWithFile:@"radio_sweep.png"];
  
  
  [sprite setScaleX:0.5f];
  [sprite setScaleY:0.5f];
  [self addChild:sprite];
  
  _radar.position = ccp(52, 90);
  [sprite addChild:_radar];
  
  //add radar animation
  id rot1 = [CCRotateBy actionWithDuration: 2 angle:359];  
  [_radar runAction: [CCRepeatForever actionWithAction:rot1]];
  
  // set physics
  cpBody *body = shape->body;
  //cpBodyApplyImpulse(shape->body, ccp(0,-15),cpvzero); // one time push.
  //cpBodyApplyForce(shape->body, ccp(0,-10),cpvzero); // maintains push over time. 
  cpBodySetVelLimit(body, 80);
  body->velocity_func = gravityVelocityFunc;
  body->data = self;
  
  _lastPosition = shape->body->p;
  _isThrusting = false;
  _shape = shape;
  _sprite = sprite;
  return self;
}

- (void) step:(ccTime) delta
{
  cpFloat angle = _shape->body->a + (_angle - _shape->body->a) * delta;
  cpBodySetAngle(_shape->body, angle);

  if (_isThrusting)
  {
    cpVect force = cpvforangle(_shape->body->a);
    force = cpvmult(cpvperp(force), GREEDYTHRUST * delta);
    cpBodyApplyImpulse(_shape->body, force,cpvzero);
    return;
  }
  
  cpBodyApplyImpulse(_shape->body, ccp(0, (50 * delta) * -1),cpvzero);
}

- (void) draw
{
#if IS_DEBUG_MODE == kDebugTrue
  // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	//draw the ship
	cpPolyShape *poly = (cpPolyShape *)_shape;
	glVertexPointer(2, GL_FLOAT, 0, poly->tVerts);
	glColor4f(0.0f, 0.0f, 1.0f, 1.0f);
	glDrawArrays(GL_TRIANGLE_FAN, 0, poly->numVerts);
  
  // restore default GL state
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
#endif
}

- (void) applyThrust
{
  _isThrusting = true;
}

- (void) removeThrust
{
  _isThrusting = false;
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

@end