//
//  GreedyGameLayer.m
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 Digital Five. All rights reserved.
//

#import "GameLayer.h"
#import "GameScene.h"
#import "GameEnvironment.h"
#import "chipmunk.h"
#import "SpaceManager.h"
#import "GameScene.h"

@implementation GameLayer
@synthesize greedy = _greedy;

// using law of cosines, we can calculate the vector between the player and
// the landing pad with this formula
// (x,y) =>
//    x = distance * cos(angle)
//    y = distance * sin(angle)
static inline CGPoint
ccpGetOffset(const double angle, const int distance)
{
  double x,y;
  x = distance * cos(angle);
  y = distance * sin(angle);
  return CGPointMake(x,y);
}

// reduces the first point to (0,0) then
// subtracts a from b. once that is done
// it will return the angle from (0,0).
static inline CGPoint 
ccpAngleBetween(CGPoint a, CGPoint b)
{
  CGPoint offset = CGPointMake(b.x - a.x, b.y - a.y);
  return offset;
}

// on "init" you need to initialize your instance
- (id) initWithBackground:(Background *)background
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
  }
	return self;
}

- (id) initWithEnvironment:(GameEnvironment *) environment
{
  if( (self=[super init])) {
    self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
    
    // asteroids.
    GDKaosEngine *engine = [[GDKaosEngine alloc] initWorldSizeCircle:500 withDensity:3.0f];
    _asteroidField = [[AsteroidField alloc] initWithEnvironment:environment totalArea:(1800 * 500) density:0.25 Layer:LAYER_DEFAULT];
    [self addChild:_asteroidField];
    
    // greedy!
    _greedy = [[[Greedy alloc] initWith:environment startPos:cpv(0.0, -(900.0 - 40.0))] autorelease];
    [self addChild:_greedy];
    [self runAction:[CCFollow actionWithTarget:_greedy]];
    
    // add circular limits
    //[_environment addCircularWorldContainmentWithFriction:0.0 elasticity:0.01f radius:500]; 
    //[_environment addCircularWorldContainmentWithFriction:0.0 elasticity:0.1f radius:500];
    [environment addTopDownWorldContainmentWithFriction:0.0 elasticity:0.1f height:1800.0 width:500.0];
    
    _lastPosition = [_greedy position];
    
    _debugLayer = [environment.manager createDebugLayer];
    _debugLayer.visible = NO;
    [self addChild: _debugLayer];
    
    [environment.manager start:(1.0/60.0)];
    [self schedule: @selector(step:)];
  }
  return self;
}

- (void) toggleDebug;
{
  _debugLayer.visible = !_debugLayer.visible;
}

- (void) dealloc
{
  [super dealloc];
}

- (void) draw
{
  
}

- (void) SpeedBarUpdate {
 cpBody* body = _greedy.shape->body;
 float len = cpvdot(body->v,body->v); //len * len  
 float ratio = len / (body->v_limit * body->v_limit);
 int speed = (body->v_limit * ratio) / (body->v_limit / 10);
 
 [((GameScene *)(_greedy.parent.parent)).hudLayer.lifeMeter setLifeLevel:speed];
}

-(void) step: (ccTime) dt
{
  // add all the external forces , such as thrusts, asteraid attraction
  [_greedy prestep:dt];
  
  // now step the physics engine
  [_greedy postStep:dt];
  
  //move the parallax backgrounds
  CGPoint diff = ccpSub(_lastPosition, [_greedy position]);
  
  [((GameScene *)(self.parent)).background setPosition: ccpAdd([((GameScene *)(self.parent)).background position], diff)];
  
  _lastPosition = [_greedy position];
  
  //NSLog(@"Greedy Pos: %f, %f", _lastPosition.x, _lastPosition.y);
  
  //debug speed details after all forces applied and calcualted
  [self SpeedBarUpdate];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [_greedy applyThrust];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [_greedy removeThrust];
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{ 
#define kFilterFactor 0.4f	
    
  //low pass filter (remove gavity
	accelX = (float) acceleration.x * kFilterFactor + ((1.0 - kFilterFactor)*accelX);
	accelY = (float) acceleration.y * kFilterFactor + ((1.0 - kFilterFactor)*accelY);
	accelZ = (float) acceleration.z * kFilterFactor + ((1.0 - kFilterFactor)*accelZ);
  
  //high pass filter
  //accelX = (acceleration.x * kFilterFactor) + (accelX * (1.0 - kFilterFactor));
  //accelY = (acceleration.y * kFilterFactor) + (accelY * (1.0 - kFilterFactor));
  
  //orientation 
  float angle = atan2(accelY, accelX);
  angle *= 180/3.14159;
  angle += 90.0;
  if(angle < 0) angle = 360.0 + angle;
  
  //float angleX = accelX * 180/3.14159; 
  //float angleY = accelY * 180/3.14159; 
  //float angleZ = accelZ * 180/3.14159; 
  
  [_greedy setAngle:angle];
  
  //NSLog(@"\n angle [%f] accel (x => [%f][%f][%f], y => [%f][%f][%f], z => [%f][%f][%f])", angle, acceleration.x, accelX, angleX, acceleration.y, accelY, angleY, acceleration.z, accelZ, angleZ);
}

@end