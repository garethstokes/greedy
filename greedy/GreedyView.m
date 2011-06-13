//
//  GreedyView.m
//  greedy
//
//  Created by gareth stokes on 1/06/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "GreedyView.h"
#import "cocos2d.h"
#import "chipmunk.h"
#import "Greedy.h"

@implementation GreedyView
@synthesize thrusting = _thrusting;

static cpFloat
springForce(cpConstraint *spring, cpFloat dist)
{
	cpFloat clamp = 1.0f;
	return cpfclamp(cpDampedSpringGetRestLength(spring) - dist, -clamp, clamp)*cpDampedSpringGetStiffness(spring);
}

-(void) addEyeContainer:(SpaceManagerCocos2d *)manager shape:(cpShape *) shape
{
  float segCount = 16.0;
  float segAngle = 360.0 / segCount;
  float radius = 8;
  CGPoint pos = ccp(0,0);//[_sprite position];
  pos.y += 15.0;
  pos.x -= 1;
  
  float fromX, fromY = 0.0;
  float toX, toY = 0.0;
  
  for(int seg = 0; seg < segCount; seg++)
  {
    fromX = pos.x + (radius * cos( CC_DEGREES_TO_RADIANS(seg * segAngle) ) );
    fromY = pos.y + (radius * sin( CC_DEGREES_TO_RADIANS(seg * segAngle) ) );
    
    toX = pos.x + (radius * cos( CC_DEGREES_TO_RADIANS((seg + 1) * segAngle )) );
    toY = pos.y + (radius * sin( CC_DEGREES_TO_RADIANS((seg + 1) * segAngle) ) );
    
    _iris[seg] = cpSpaceAddShape(manager.space, cpSegmentShapeNew(shape->body, cpv(fromX, fromY), cpv(toX, toY), 1.0f));
    
    _iris[seg]->layers = LAYER_GREEDY_EYE;
    _iris[seg]->e = 0.5;
    _iris[seg]->u  = 0.5;
  }

  _irisBoundingCircle = cpCircleShapeNew(shape->body, 2.0, ccp(-1.0, 15.0));
  _irisBoundingCircle->sensor = YES;
  _irisBoundingCircle->layers = LAYER_GREEDY_EYE;
  cpSpaceAddShape(manager.space, _irisBoundingCircle);
}

- (id) initWithShape:(cpShape *) shape  manager:(SpaceManagerCocos2d *)manager
{
  if(!(self = [super init])) return nil;
  
  _radar = [CCSprite spriteWithFile:@"radio_sweep.png"];
  
  CCSpriteBatchNode* batch = [CCSpriteBatchNode batchNodeWithFile:@"greedy.png" capacity:50]; 
  [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"greedy.plist"];

  //Move greedy into layer DEFAULT so its shape doesn't impact eyeball or background asteroids
  shape->layers = LAYER_DEFAULT;
  
  _sprite = [cpCCSprite spriteWithShape:shape spriteFrameName:@"greedy_open_1.png"];
  [_sprite setScaleX:0.5f];
  [_sprite setScaleY:0.5f];
  
  NSMutableArray* shake_frames = [NSMutableArray array];
  [shake_frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_5_offset_a.png"]];
  [shake_frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_5_offset_b.png"]];
  
  CCAnimation *animation = [CCAnimation animationWithFrames:shake_frames delay:0.1f];
  CCAnimate *action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
  
  [_sprite runAction:[CCRepeatForever actionWithAction: action]];
  
  [batch addChild:_sprite];
  
  _radar.position = ccp(52, 90);
  [_radar setScaleX:0.5f];
  [_radar setScaleY:0.5f];
  [_radar setPosition:[_sprite position]];  
  
  //add radar animation
  id rot1 = [CCRotateBy actionWithDuration: 2 angle:359];  
  [_radar runAction: [CCRepeatForever actionWithAction:rot1]];
  
  //_sprites
  [self addChild:batch];
  [self addChild:_radar];
  
  //add crazy eye container
  [self addEyeContainer: manager shape:shape];
  
  //add crazy eye
  CGPoint eyePos = [_sprite position];
  eyePos.y += 15;
  
  cpShape *sh1 = [manager addCircleAt:eyePos mass:10.0 radius:4.0];
  sh1->layers = LAYER_GREEDY_EYE;
  _eyeBall = [[cpShapeNode alloc] initWithShape:sh1];
  _eyeBall.color = ccBLACK;
  [self addChild:_eyeBall];
		
  
  _thrusting = kGreedyThrustNone;
  
  return self;
} 

- (void) step:(ccTime) delta
{
  CGPoint pos = [_sprite position];
  
  [_radar setPosition:pos];
  
  //update the pupil to keep it clamped inside the iris
  CGPoint irisPos =  ((cpCircleShape *)(_irisBoundingCircle))->tc;
  CGPoint pupilPos = _eyeBall.position;
 
  if(!cpvnear(pupilPos, irisPos, 4.0))
  {
    cpVect dxdy = cpvnormalize_safe(cpvsub(pupilPos, irisPos));	
    CGPoint newPos = cpvadd(irisPos, cpvmult(dxdy, 4.0));
    cpBodySetPos(_eyeBall.shape->body, newPos);
    cpBodyResetForces(_eyeBall.shape->body);
  }
  
  //add down force (not a gravity just a "forcy thing")
  cpBodyApplyImpulse(_eyeBall.shape->body, ccp(0, (-100 * delta)),cpvzero); 
}

-(void) dealloc
{
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[super dealloc];
}

@end