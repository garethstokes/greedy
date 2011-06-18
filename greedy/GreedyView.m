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
  float radius = 6;
  CGPoint pos = ccp(0,0);//[_sprite position];
  pos.y += 8.0;
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

  _irisBoundingCircle = cpCircleShapeNew(shape->body, 2.0, ccp(-1.0, 8.0));
  _irisBoundingCircle->sensor = YES;
  _irisBoundingCircle->layers = LAYER_GREEDY_EYE;
  cpSpaceAddShape(manager.space, _irisBoundingCircle);
}

- (id) initWithShape:(cpShape *) shape  manager:(SpaceManagerCocos2d *)manager
{
  if(!(self = [super init])) return nil;
  
  _radar = [CCSprite spriteWithFile:@"radio_sweep.png"];
  
  _batch = [CCSpriteBatchNode batchNodeWithFile:@"greedy.png" capacity:50]; 
  [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"greedy.plist"];

  //Move greedy into layer DEFAULT so its shape doesn't impact eyeball or background asteroids
  shape->layers = LAYER_DEFAULT;
  
  _sprite = [cpCCSprite spriteWithShape:shape spriteFrameName:@"greedy_open_1.png"];
  [_sprite setScaleX:0.5f];
  [_sprite setScaleY:0.5f];
  [_batch addChild:_sprite];
  
  _radar.position = ccp(52, 90);
  [_radar setScaleX:0.5f];
  [_radar setScaleY:0.5f];
  [_radar setPosition:[_sprite position]];  
  
  //add radar animation
  id rot1 = [CCRotateBy actionWithDuration: 2 angle:359];  
  [_radar runAction: [CCRepeatForever actionWithAction:rot1]];
  
  //_sprites
  [self addChild:_batch];
  [self addChild:_radar];
  
  //add crazy eye container
  [self addEyeContainer: manager shape:shape];
  
  //add crazy eye
  CGPoint eyePos = [_sprite position];
  eyePos.y += 8;
  
  cpShape *sh1 = [manager addCircleAt:eyePos mass:10.0 radius:3.0];
  sh1->layers = LAYER_GREEDY_EYE;
  _eyeBall = [[cpShapeNode alloc] initWithShape:sh1];
  static const ccColor3B ccGreedyEye = {33,33,33};
  _eyeBall.color = ccGreedyEye;
  [self addChild:_eyeBall];
		
  _thrusting = kGreedyThrustNone;
  _shape = shape;
  
  return self;
} 

- (void) step:(ccTime) delta
{
  CGPoint pos = [_sprite position];
  
  [_radar setPosition:pos];

  if (_flames != nil)
  {
    [_flames setRotation:[_sprite rotation]];
    cpFloat angle = _sprite.shape->body->a;
    cpVect offset = cpvrotate(cpvforangle(angle), ccp(0, -40));
    [_flames setPosition:cpvadd([_sprite position], offset)];
  }
  
  //update the pupil to keep it clamped inside the iris
  CGPoint irisPos =  ((cpCircleShape *)(_irisBoundingCircle))->tc;
  CGPoint pupilPos = _eyeBall.position;
    
 
  if(!cpvnear(pupilPos, irisPos, 3.0))
  {
    cpVect dxdy = cpvnormalize_safe(cpvsub(pupilPos, irisPos));	
    CGPoint newPos = cpvadd(irisPos, cpvmult(dxdy, 3.0));
    cpBodySetPos(_eyeBall.shape->body, newPos);
    cpBodyResetForces(_eyeBall.shape->body);
  }
  
  //add down force (not a gravity just a "forcy thing")
  cpBodyApplyImpulse(_eyeBall.shape->body, ccp(0, (-100 * delta)),cpvzero); 
}

- (void) setThrusting:(int)value
{
  if (value == kGreedyThrustNone)
  {
    NSLog(@"update thrusting: nill");
    
    [self removeChild:_flames cleanup:YES];
    _flames = nil;
    
    _thrusting = value;
    return;
  }
  
  if (value >= kGreedyThrustLittle)
  {
    NSLog(@"update thrusting: zomg flames!");    

    NSMutableArray *flameFrames = [NSMutableArray array];
    [flameFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"flames_3.png"]];
    [flameFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"flames_4.png"]];
    [flameFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"flames_5.png"]];
    [flameFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"flames_6.png"]];
    [flameFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"flames_7.png"]];
    
    CCAnimation *animation = [CCAnimation animationWithFrames:flameFrames delay:0.1f];
    CCAnimate *action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]] retain];
    
    _flames = [CCSprite spriteWithSpriteFrameName:@"flames_3.png"];
    _flames.position = ccp(50, 90);
    [_flames setScaleX:0.5f];
    [_flames setScaleY:0.5f];
    [_flames setPosition:ccpAdd([_sprite position], ccp(0, -100))];  
    [_flames runAction:action];
    
    [self addChild:_flames z:-1];
    
    _thrusting = value;
    return;
  }
}

- (BOOL) isThrusting
{
  return (_thrusting > 1);
}

- (void) updateFeeding:(int)value
{
//  return;
  
  if (value == kGreedyIdle)
  {
    NSLog(@"update feeding: idle");
    _sprite = [cpCCSprite spriteWithShape:_shape spriteFrameName:@"greedy_open_1.png"];
    [_sprite setScaleX:0.5f];
    [_sprite setScaleY:0.5f];
  }
  
  if (value >= kGreedyEating)
  {
    NSLog(@"update feeding: eating");
    CCAnimation *animation = [CCAnimation animationWithFrames:_flameFrames delay:0.1f];
    CCAnimate *action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]] retain];
    
    [_sprite runAction:[CCRepeatForever actionWithAction: action]];
    return;
  }
}

-(void) dealloc
{
  NSLog(@"Dealloc GreedyView");
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[super dealloc];
}

@end