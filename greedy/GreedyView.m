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

- (float) getEyePositionForCurrentSprite
{
  if (_feeding == kGreedyIdle) return 7.0f;
  if (_feeding == kGreedyEating) return 15.0f;
  return 15.0f;
}

-(void) addEyeContainer:(SpaceManagerCocos2d *)manager shape:(cpShape *) shape
{  
  float segCount = 16.0;
  float segAngle = 360.0 / segCount;
  float radius = 6;
  CGPoint pos = ccp(0,0);
  pos.y += [self getEyePositionForCurrentSprite];
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

  float p = [self getEyePositionForCurrentSprite];
  _irisBoundingCircle = cpCircleShapeNew(shape->body, 2.0, ccp(-1.0, p));
  _irisBoundingCircle->sensor = YES;
  _irisBoundingCircle->layers = LAYER_GREEDY_EYE;
  cpSpaceAddShape(manager.space, _irisBoundingCircle);
}

- (void) addCrazyEye:(SpaceManagerCocos2d *)manager
{  
  //add crazy eye
  CGPoint eyePos = [_sprite position];
  eyePos.y += [self getEyePositionForCurrentSprite];
  
  cpShape *sh1 = [manager addCircleAt:eyePos mass:10.0 radius:3.0];
  sh1->layers = LAYER_GREEDY_EYE;
  _eyeBall = [[[cpShapeNode alloc] initWithShape:sh1] retain];
  static const ccColor3B ccGreedyEye = {33,33,33};
  _eyeBall.color = ccGreedyEye;
  [self addChild:_eyeBall];
}

- (void) removeCrazyEyeAndContainer
{
  [self removeChild:_eyeBall cleanup:YES];
  [_eyeBall release];
  for(int i = 0; i < 16; i++)
  {
    cpSpaceRemoveShape(_manager.space, _iris[i]);
    cpShapeFree(_iris[i]);
    _iris[i] = nil;
  }
  
  cpSpaceRemoveShape(_manager.space, _irisBoundingCircle);
  cpShapeFree(_irisBoundingCircle);
  _irisBoundingCircle = nil;
}

- (void) createSprites
{
  //load in the masters files ... ie the PNG and zwoptex plist
  _batch = [CCSpriteBatchNode batchNodeWithFile:@"greedy.png" capacity:50]; 
  [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"greedy.plist"]; 
  
  
  //Create sequences
  
  
  //flame
  NSMutableArray *flameFrames = [NSMutableArray array];
  [flameFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"flames_3.png"]];
  [flameFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"flames_4.png"]];
  [flameFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"flames_5.png"]];
  [flameFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"flames_6.png"]];
  [flameFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"flames_7.png"]];

  CCAnimation *animation = [CCAnimation animationWithFrames:flameFrames delay:0.1f];
  [[CCAnimationCache sharedAnimationCache] addAnimation:animation name:@"flames"];
  _actionFlame = [CCAnimate actionWithDuration:0.1 animation:[[CCAnimationCache sharedAnimationCache] animationByName:@"flames"] restoreOriginalFrame:NO];
  
  //openUp
  NSMutableArray *_aryOpenUp = [NSMutableArray array];
  [_aryOpenUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_1.png"]];
  [_aryOpenUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_2.png"]];
  [_aryOpenUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_3.png"]];
  [_aryOpenUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_4.png"]];
  [_aryOpenUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_5.png"]];
  
  _animationOpenUp = [CCAnimation animationWithFrames:_aryOpenUp];
  _actionOpenUp    = [[CCAnimate actionWithDuration:0.05 animation:_animationOpenUp restoreOriginalFrame:NO] retain];
  
  //closeDown
  _actionCloseDown = [[_actionOpenUp reverse] retain];
  [_actionCloseDown setDuration:0.2];
  
  //head wobble open
  NSMutableArray *wobbleFrames = [NSMutableArray array];
  
  [wobbleFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_5_offset_a.png"]];
  [wobbleFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_5_offset_b.png"]];
  
  CCAnimation *animationWobble = [CCAnimation animationWithFrames:wobbleFrames delay:0.1f];
  _actionWobble = [[CCRepeatForever actionWithAction:[CCAnimate actionWithDuration:0.2 animation:animationWobble restoreOriginalFrame:NO]] retain];
  

}

- (id) initWithShape:(cpShape *)shape  manager:(SpaceManagerCocos2d *)manager radar:(cpShape *)radar
{
  if(!(self = [super init])) return nil;
  
  //_greedy = greedy;
  //cpShape *shape = greedy->shape;
  
  _shape = shape;
  _manager = manager;
  _radarShape = radar;
  
  _thrusting = kGreedyThrustNone;
  _feeding = kGreedyIdle;
  [self createSprites];
  
  //Move greedy into layer DEFAULT so its shape doesn't impact eyeball or background asteroids
  shape->layers = LAYER_DEFAULT;
 
  //Body
  _sprite = [cpCCSprite spriteWithShape:shape spriteFrameName:@"greedy_open_1.png"];
  [_sprite setScaleX:0.5f];
  [_sprite setScaleY:0.5f];
  [_batch addChild:_sprite];
  
  //_sprites
  [self addChild:_batch];
  [self goIdle:_sprite];
  
  //add crazy eye container
  [self addEyeContainer: manager shape:shape];
  [self addCrazyEye:manager];
  
  return self;
} 

- (void) step:(ccTime) delta
{
  if (_radar != nil)
  {
    CGPoint pos = [_sprite position];
    [_radar setPosition:pos];
    [_radar setRotation: CC_RADIANS_TO_DEGREES( - _radarShape->body->a)];
  }
  
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
 
  if(!cpvnear(pupilPos, irisPos, 2.0))
  {
    cpVect dxdy = cpvnormalize_safe(cpvsub(pupilPos, irisPos));	
    CGPoint newPos = cpvadd(irisPos, cpvmult(dxdy, 2.0));
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
    NSLog(@"update thrusting: nil");
    
    [_batch removeChild:_flames cleanup:YES];
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
    CCAnimate *action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    
    _flames = [CCSprite spriteWithSpriteFrameName:@"flames_3.png"];
    _flames.position = ccp(50, 90);
    [_flames setScaleX:0.5f];
    [_flames setScaleY:0.5f];
    [_flames setPosition:ccpAdd([_sprite position], ccp(0, -100))];  
    [_flames runAction:action];
    
    [_batch addChild:_flames z:-1];
    
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
  _feeding = value;
  
  if (value == kGreedyIdle)
  {
    NSLog(@"update feeding: idle");
    
    [self stopRadar];
    
    // eyeballz
    [self removeCrazyEyeAndContainer];
    
    [self addEyeContainer:_manager shape:_shape];

    [self addCrazyEye:_manager];
    
    [self closeDown];
    
    return;
  }
  
  if (value >= kGreedyEating)
  {
    NSLog(@"update feeding: eating");
   
    [self startRadar];
    
    // eyeballz
    [self removeCrazyEyeAndContainer];
    
    [self addEyeContainer:_manager shape:_shape];
    
    [self addCrazyEye:_manager];
    
    [self openUp];
    
    return;
  }
}


- (void) startRadar
{
  // radar
  if(_radar == nil)
  {
    _radar = [CCSprite spriteWithFile:@"radio_sweep.png"];    
    [_radar setScaleX:0.5f];
    [_radar setScaleY:0.5f];
    [_radar setPosition:[_sprite position]];  
    [_radar setRotation: _radarShape->body->a];
    
    //add radar animation
    //id rot1 = [CCRotateBy actionWithDuration: 3 angle:359];  
    //[_radar runAction: [CCRepeatForever actionWithAction:rot1]];
    [self addChild:_radar];
  }
}

- (void)  updateRadarPosition:(id)sender
{
   //cpBodySetAngle(_radarLine->body, [_radar rotation]);
}

- (BOOL) handleCollisionRadar:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
  NSLog(@"Radar detected asteroid");

  return YES;
}

- (void) stopRadar
{
  if(_radar != nil)
  {
    [self stopAllActions]; //remove the radar updater
    
    [self removeChild:_radar cleanup:YES];
    
    _radar = nil;  
  }
}

-(void) openUp
{
  [_sprite stopAllActions];
  [_sprite runAction:[CCSequence actions:_actionOpenUp, 
                      [CCCallFuncN actionWithTarget:self selector:@selector(wobbleHead:)],
                      nil]];
}

-(void) closeDown
{ 
  [_sprite stopAllActions];
  [_sprite runAction:[CCSequence actions:_actionCloseDown,
                      [CCCallFuncN actionWithTarget:self selector:@selector(goIdle:)],
                      nil]];
}

-(void) wobbleHead:(id)sender
{
  [_sprite stopAllActions];
	[sender runAction:_actionWobble];
}

-(void) goIdle:(id)sender
{
  _feeding = kGreedyIdle;
  [sender stopAllActions];
	[sender setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_close_body.png"]];
}

-(void) dealloc
{
  NSLog(@"Dealloc GreedyView");
  [_actionCloseDown release];
  [_actionFlame release];
  [_actionOpenUp release];
  [_actionWobble release];
  [self removeCrazyEyeAndContainer];
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[super dealloc];
}

@end