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
  
  for(int seg = 0; seg < segCount; seg++)
  {
    float fromX, fromY = 0.0;
    float toX, toY = 0.0;
    
    CGPoint pos = [_sprite position];
    pos.y += 15.0;
    pos.x -= 1;
    
    fromX = pos.x + (radius * cos( CC_DEGREES_TO_RADIANS(seg * segAngle) ) );
    fromY = pos.y + (radius * sin( CC_DEGREES_TO_RADIANS(seg * segAngle) ) );
    
    toX = pos.x + (radius * cos( CC_DEGREES_TO_RADIANS((seg + 1) * segAngle )) );
    toY = pos.y + (radius * sin( CC_DEGREES_TO_RADIANS((seg + 1) * segAngle) ) );
    
    _iris[seg] = cpSpaceAddShape(manager.space, cpSegmentShapeNew(shape->body, cpv(fromX, fromY), cpv(toX, toY), 1.0f));
    
    _iris[seg]->layers = 2;
    _iris[seg]->e = 1.0;
    _iris[seg]->u  = 1.0;
  }

}

- (id) initWithShape:(cpShape *) shape  manager:(SpaceManagerCocos2d *)manager
{
  if(!(self = [super init])) return nil;
  
  _radar = [CCSprite spriteWithFile:@"radio_sweep.png"];
  
  CCSpriteBatchNode* batch = [CCSpriteBatchNode batchNodeWithFile:@"greedy.png" capacity:50]; 
  [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"greedy.plist"];
  
  //shape->group = (cpGroup)LAYER_GREEDY;
  shape->layers = 1;
  
  _sprite = [cpCCSprite spriteWithShape:shape spriteFrameName:@"greedy_open_1.png"];
  [_sprite setScaleX:0.5f];
  [_sprite setScaleY:0.5f];
  
//  NSMutableArray* shake_frames = [NSMutableArray array];
//  [shake_frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_5_offset_b.png"]];
//  
//  CCAnimation *animation = [CCAnimation animationWithFrames:shake_frames delay:0.1f];
//  CCAnimate *action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]] retain];
  
//  [_sprite runAction:[CCRepeatForever actionWithAction: action]];
  
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
  
  cpShape *sh1 = [manager addCircleAt:eyePos mass:20.0 radius:4];
  //sh1->group = (cpGroup)LAYER_GREEDY; 
  sh1->layers = 2;
  _eyeBall = [[cpShapeNode alloc] initWithShape:sh1];
  _eyeBall.color = ccBLACK;
  [self addChild:_eyeBall];
  
  //cpConstraint *spring = cpSpaceAddConstraint(manager.space, cpDampedSpringNew(sh1->body, shape->body, cpv(0.0f, 0.0f), cpv(-1.0f, 15.0f), 5.0, 100.0, 0.5));
  //cpDampedSpringSetSpringForceFunc(spring, springForce);
  //cpConstraint *pin = cpSpaceAddConstraint(manager.space, cpPinJointNew(sh1->body, shape->body, cpv(0.0f, 0.0f), cpv(0.0f, 14.0f)));
  //cpDampedSpringSetSpringForceFunc(spring, springForce);
  //cpSpaceAddConstraint(manager.space, cpDampedSpringNew(sh1->body, shape->body, cpv(0.0f, 0.0f), cpv(-1.0f, 15.0f), 0.0, 20.0, 1.5));
  //cpSpaceAddConstraint(manager.space, cpDampedRotarySpringNew(sh1->body, shape->body, CC_DEGREES_TO_RADIANS(90), 100.0, 0.5));
  		
  
  _thrusting = kGreedyThrustNone;
  _shape = shape;
  
  return self;
} 

- (void) step:(ccTime) delta
{
  CGPoint pos = [_sprite position];
  
  [_radar setPosition:pos];
  
  pos.y += 15;
  for (int i = 0; i < 16; i++) {
//    cpShape *segment = _iris[i];
//    cpBodySetPos(segment->body, pos);
  }
  
  //add down force (not a gravity just a "forcy thing")
  cpBodyApplyImpulse(_eyeBall.shape->body, ccp(0, (GREEDYTHRUST/4 * delta) / 500 * - 1),cpvzero); 
  //[_eyeBall setPosition:[_sprite position]];
}

- (void) updateFeeding:(int)value
{
  NSLog(@"update feeding: %i", value);
  return;
  
  if (value == kGreedyIdle)
  {
    _sprite = [cpCCSprite spriteWithShape:_shape spriteFrameName:@"greedy_open_1.png"];
    [_sprite setScaleX:0.5f];
    [_sprite setScaleY:0.5f];
  }
  
  if (value >= kGreedyEating)
  {
    NSMutableArray* shake_frames = [NSMutableArray array];
    [shake_frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_5_offset_b.png"]];
    
    CCAnimation *animation = [CCAnimation animationWithFrames:shake_frames delay:0.1f];
    CCAnimate *action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]] retain];
    
    [_sprite runAction:[CCRepeatForever actionWithAction: action]];
    return;
  }
}

@end