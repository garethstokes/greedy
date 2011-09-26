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
#import "AsteroidSprite.h"

@implementation Greedy
@synthesize shape = _shape;
@synthesize feedingCount = _feedingCount;
@synthesize score = _score;
@synthesize fuel = _fuel;
@synthesize view = _view;

- (void) addRadarSensor: (cpBody *) body manager: (SpaceManagerCocos2d *) manager  {
  //Add radar
  //Add the Radar sensor
  cpShape *radarshape = cpCircleShapeNew(body, 120.0, cpvzero);  
  radarshape->e = .5; 
	radarshape->u = .5;
  radarshape->group = 0;
  radarshape->layers = LAYER_RADAR;
	radarshape->collision_type = kGreedyRadarCollisionType;
  radarshape->sensor = YES;
	radarshape->data = nil;
  cpSpaceAddShape(manager.space, radarshape);
  [manager addCollisionCallbackBetweenType: kGreedyRadarCollisionType
                                 otherType: kAsteroidCollisionType 
                                    target: self 
                                  selector: @selector(handleCollisionRadar:arbiter:space:)];
  
}

- (id) initWith:(GameEnvironment *)environment startPos:(cpVect)startPos
{
  CCLOG(@" Greedy: initWith");
  
  if(!(self = [super init])) return nil;
  
  SpaceManagerCocos2d *manager = [environment manager];
  
  _manager = manager;
  
  cpShape *shape = [manager 
                    addRectAt:startPos 
                    mass:GREEDYMASS 
                    width:50 
                    height:75 
                    rotation:0];
  
  shape->layers = LAYER_GREEDY;
  shape->collision_type = kGreedyCollisionType;
  
  shape->u = 0.9f; //friction
  
  // set physics
  cpBody *body = shape->body;
  cpBodySetVelLimit(body, 80);
  body->data = self;
  
  _lastPosition = shape->body->p;
  _shape        = shape;
  
  _fuel = 10;
  
  _exploded = NO;
  
  [self createRadarLine:manager];
  
  //init collisions
	[manager addCollisionCallbackBetweenType: kAsteroidCollisionType 
                                 otherType: kGreedyCollisionType 
                                    target: self 
                                  selector: @selector(handleCollisionWithAsteroid:arbiter:space:)];
  
  //add radar
  [self addRadarSensor: body manager: manager];
  
  // view
  _view = [[GreedyView alloc] initWithShape:shape manager:manager radar:_radarShape];
  [self addChild:_view];
  
  return self;
}

- (BOOL) handleCollisionWithAsteroid:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
  if (_exploded) return YES;
  
	if (moment == COLLISION_POSTSOLVE)
	{
		//NSLog(@"You hit an asteroid!!!");
    
    CP_ARBITER_GET_SHAPES(arb,a,b);
    
    //cpVect p = cpArbiterGetPoint(arb, 0);
    
    //CCParticleSystemQuad *puff = [CCParticleSystemQuad particleWithFile:@"AsteroidPuff.plist"];
    
    //[puff setPosition:p];
    //[puff setDuration:2.0];
    //[self addChild:puff];
    
    float bumpStrength = cpvlength(cpArbiterTotalImpulse(arb));
    
    //reduce the fuel
    if ((bumpStrength > 1.0) && (_fuel > 0.0))
    {
#define FUELBUMP 1
      CCLOG(@"Asteroid Bump %f", bumpStrength);
      // _fuel -= (FUELBUMP * bumpStrength);
      if (_fuel < 0.0){
        [self removeThrust];
        _fuel = 0.0;
      }
    }
	}
  
	return YES;
}

static void setGreedyEatingState(cpSpace *space, void *obj, void *data)
{
  Greedy *g = (Greedy*)(obj);
  
  if(data == nil)
    [g setEatingStatusTo:kGreedyIdle];
  else
    [g setEatingStatusTo:kGreedyEating];
}

static void addGreedyPoint(cpSpace *space, void *obj, void *data)
{
  Greedy *g = (Greedy*)(obj);
  cpVect *p = (cpVect *)data;
  
  CCParticleSystemQuad *sparkle = [CCParticleSystemQuad particleWithFile:@"sparkle.plist"];
  [sparkle setPosition:p[0]];
  [sparkle setDuration:0.1];
  
  [g addChild:sparkle];
  
  free(p);
}

- (BOOL) handleCollisionRadarLine:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	if (_exploded) return YES;
  
  if (moment == COLLISION_BEGIN)
	{
    //CCLOG(@"Line Meets asteroid begin");
    
    CP_ARBITER_GET_SHAPES(arb, a, b);
    AsteroidSprite * ast = (AsteroidSprite *)(b->data);
    cpFloat len = cpArbiterGetDepth(arb, 0);
    
    float oreScore = [ast mineOre:1.0 length:len];
    
    if( oreScore > 0)
    { 
      _score += oreScore;
      
      cpVect *p = malloc(sizeof(cpVect));
      p[0] = cpArbiterGetPoint(arb, 0);
      
      cpSpaceAddPostStepCallback(space, addGreedyPoint, self, p);
    }
  }
  
  if (moment == COLLISION_PRESOLVE)
	{
    //CCLOG(@"Line Meets asteroid post solve");
    CP_ARBITER_GET_SHAPES(arb, a, b);
    AsteroidSprite * ast = (AsteroidSprite *)(b->data);
    cpFloat len = cpArbiterGetDepth(arb, 0);
    
    float oreScore = [ast mineOre:1.0 length:len];
    
    if( oreScore > 0)
    { 
      _score += oreScore;
      
      cpVect *p = malloc(sizeof(cpVect));
      p[0] = cpArbiterGetPoint(arb, 0);
      
      cpSpaceAddPostStepCallback(space, addGreedyPoint, self, p);
    }
  }
  
  if (moment == COLLISION_SEPARATE)
  {
    //CCLOG(@"Line Leaves asteroid end");
  }
  
  return YES;
}

- (BOOL) handleCollisionRadar:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
  if (_exploded) return YES;
  
	if (moment == COLLISION_BEGIN)
	{
		CCLOG(@"You are within radar range... woot!!!");
    
    if(_feedingCount == 0)
      cpSpaceAddPostStepCallback(space, setGreedyEatingState, self, self); // Set secound param to self just toprovide a simple flag
    
    _feedingCount++;
    
    CCLOG(@"Greedy Feed Count %d", _feedingCount);
	}
  
  if (moment == COLLISION_SEPARATE)
  {
    CCLOG(@"You are no longer in radar range... :( !!!");
    
    _feedingCount--;
    if(_feedingCount == 0)
      cpSpaceAddPostStepCallback(space, setGreedyEatingState, self, nil);
    
    CCLOG(@"Greedy Feed Count %d", _feedingCount);
  }
  
	return YES;
}

- (void) createRadarLine:(SpaceManagerCocos2d *) manager
{
  if(_radarShape == nil)
  {
    _radarShape = [manager addSegmentAt:_shape->body->p fromLocalAnchor:ccp(0,0) toLocalAnchor:ccp(130, 0) mass:1.0 radius:2.0];
    _radarShape->sensor = YES;
    _radarShape->layers = LAYER_RADARLINE;
    _radarShape->collision_type = kGreedyRadarlineCollisionType;
    
    [manager addPinToBody:_shape->body fromBody:_radarShape->body toBodyAnchor:ccp(0,0) fromBodyAnchor:ccp(0,0)];
    
    [manager addCollisionCallbackBetweenType: kGreedyRadarlineCollisionType
                                   otherType: kAsteroidCollisionType 
                                      target: self 
                                    selector: @selector(handleCollisionRadarLine:arbiter:space:)];
  }
}

static void explodeGreedy(cpSpace *space, void *obj, void *data)
{
  Greedy *g = (Greedy*)(obj);
  SpaceManagerCocos2d * manager = (SpaceManagerCocos2d *)data;
  
  cpBodyResetForces(g.shape->body);
  cpBodySleep(g.shape->body);
  
  cpSpaceRemoveBody(manager.space, g.shape->body);
  
  [g.view explode];
}

- (void) burnFuel:(float)amount
{
  if(_fuel > 0.0){
    _fuel -= amount;
    if (_fuel < 0.0){
      [self removeThrust];
      _fuel = 0.0;
      [self explode];
    }
  }
}

- (void) explode
{
  if(!_exploded)
  {
    cpSpaceAddPostStepCallback(_manager.space, explodeGreedy, self, _manager);
    
    [self.parent schedule:@selector(endLevelWithDeath) interval:3.0f];
  }
  _exploded = YES;
}

- (void) prestep:(ccTime) delta
{
  if(!_exploded){
    //set angle of greedy
    cpBodySetAngle(_shape->body, CC_DEGREES_TO_RADIANS(_angle));
    
    //Rotate the Radar
    static cpFloat ONEDEGREE = CC_DEGREES_TO_RADIANS(1);
    cpBodySetAngle(_radarShape->body, _radarShape->body->a - (ONEDEGREE * RADAR_SPIN_DEGREES_PER_SECOND) * delta);
    
    if ([_view isThrusting])
    {
      //add force to greedy
      cpVect force = cpvforangle(_shape->body->a);
      force = cpvmult(cpvperp(force), GREEDYTHRUST * delta);
      cpBodyApplyImpulse(_shape->body, force,cpvzero);
      
      //reduce the fuel
      [self burnFuel:(FUELRATE * delta)];
    }
    else
    {
      cpVect velocity = _shape->body->v;
      NSLog(@"greedy velocity: %d", abs(velocity.y));
      
      if (abs(velocity.y) > 5)
      {
        //add down force (not a gravity just a "forcy thing")
        cpBodyApplyImpulse(_shape->body, ccp(0, (GREEDYTHRUST/1.0f * delta) * -1),cpvzero);
      }
    }
  } else
  {
    
  }
  
}

- (void) postStep:(ccTime) delta
{
  //update the view
  if(!_exploded)
    [_view step:delta];
}

- (void) applyThrust
{
  if(!_exploded){
    //if ([_view removingThrust]) return;
    
    if (_fuel <= 0.0) return;
    
    NSLog(@"applying thrust...");
    
    [_view setThrusting:kGreedyThrustLittle];
  }
}

- (void) removeThrust
{
  NSLog(@"removing thrust...");
  if(!_exploded)
    [_view setThrusting:kGreedyThrustNone];
  else {
  }
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
  if(!_exploded)
    [_view updateFeeding:value];
}

- (BOOL) hasExploded
{
  return _exploded;
}


- (void)dealloc
{
  CCLOG(@"Dealloc Greedy");
  _fuel = 0;
  [_view release];
  [self removeAllChildrenWithCleanup:YES];
  [super dealloc];
}

@end