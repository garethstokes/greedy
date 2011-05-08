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

- (id) initWith:(GameEnvironment *)environment
{
  if(!(self = [super init])) return nil;
  
  SpaceManagerCocos2d *manager = [environment manager];
  cpShape *shape = [manager 
                    addRectAt:ccp(100,200) 
                    mass:1.0f 
                    width:50 
                    height:75 
                    rotation:0];
  
  
  cpCCSprite *sprite = [cpCCSprite 
                            spriteWithShape:shape 
                            file:@"greedy_open_5.png"];
  
  [sprite setScaleX:0.5f];
  [sprite setScaleY:0.5f];
  [self addChild:sprite];
  
  // set physics
  //cpBodyApplyImpulse(shape->body, ccp(0,-15),cpvzero); // one time push.
  cpBodyApplyForce(shape->body, ccp(0,-10),cpvzero); // maintains push over time. 
  cpBodySetVelLimit(shape->body, 50);
  

  _isThrusting = false;
  _shape = shape;
  _sprite = sprite;
  return self;
}

- (void) step:(ccTime) delta
{
  if (_isThrusting)
  {
    cpVect force = cpvforangle(_shape->body->a);
    force = cpvmult(cpvperp(force), 4);
    cpBodyApplyImpulse(_shape->body, force,cpvzero);
    return;
  }
  
  cpBodyApplyImpulse(_shape->body, ccp(0,-2),cpvzero);
  
  //cpBody *body = _shape->body;
  //NSLog(@"body force: (x => %f, y => %f)", body->f.x, body->f.y);
  //NSLog(@"body velocity: (x => %f, y => %f)", body->v.x, body->v.y);
  //NSLog(@"body angle: %f", body->a);
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
  cpBody *body = _shape->body;
  cpBodySetAngle(body, value);
}


@end