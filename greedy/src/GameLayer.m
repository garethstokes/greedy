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
    _asteroidField = [[AsteroidField alloc] initWithEnvironment:environment totalArea:(1800 * 300) density:5.0f Layer:LAYER_DEFAULT];
    [self addChild:_asteroidField];
    
    // greedy!
    _greedy = [[Greedy alloc] initWith:environment startPos:cpv(0.0, -(900.0 - 40.0))];
    [self addChild:_greedy];
    
    // add limits
    [environment addTopDownWorldContainmentWithFriction:1.0f elasticity:0.1f height:1800.0 width:350.0];
    
    _lastPosition = [_greedy position];
    
    // debug layer
    _debugLayer = [environment.manager createDebugLayer];
    _debugLayer.visible = NO;
    [self addChild: _debugLayer];
    
    // start and end points
    CCSprite *startPoint = [CCSprite spriteWithFile:@"start_point.png"];
    [startPoint setPosition:ccpAdd([_greedy position], ccp(0, 100))];
    [self addChild:startPoint z:-1];
    
    CCSprite *endPoint = [CCSprite spriteWithFile:@"end_point.png"];
    [endPoint setPosition:ccpAdd([_greedy position], ccp(0, 1600))];
    [self addChild:endPoint z:-1];    
    
    //camera
    _cameraPosition = [_greedy position];
    [self.camera setCenterX:-160 centerY:_cameraPosition.y - 240 centerZ:0];
    [self.camera setEyeX:-160 eyeY:_cameraPosition.y - 240 eyeZ:90];
    
    [environment.manager start:(1.0/60.0)];
    [self schedule: @selector(step:)];
    [self schedule: @selector(checkForAsteroids:) interval:(1.0 / 2.0)];
  }
  return self;
}

- (void) toggleDebug;
{
  _debugLayer.visible = !_debugLayer.visible;
}

- (void) dealloc
{
  NSLog(@"Dealloc GameLayer");
  [ self removeAllChildrenWithCleanup:YES];
  [_asteroidField release];
  [_greedy release];
  [super dealloc];
}

- (void) SpeedBarUpdate {
 cpBody* body = _greedy.shape->body;
 float len = cpvdot(body->v,body->v); //len * len  
 float ratio = len / (body->v_limit * body->v_limit);
 int speed = (body->v_limit * ratio) / (body->v_limit / 10);
 
 [((GameScene *)(_greedy.parent.parent)).hudLayer.lifeMeter setLifeLevel:speed];
}

- (void) checkForAsteroids:(ccTime) dt
{
  // loop through asteroids and determine if any are close to greedy
  float magnitude = 0;
  for (Asteroid *a in [_asteroidField asteroids]) {
    float m = ccpDistance([a position], [_greedy position]);     
    if (magnitude == 0) 
    {
      magnitude = m;
      continue;
    }
    if (m < magnitude) magnitude = m;
  }
  
  if (magnitude < 100)
  {
    //NSLog(@"watch out greedy! ...an asteroid is near you!");
    [_greedy setEatingStatusTo:kGreedyEating];
    return;
  }
  
  [_greedy setEatingStatusTo:kGreedyIdle];
}

-(void) step: (ccTime) dt
{
  // add all the external forces , such as thrusts, asteraid attraction
  [_greedy prestep:dt];
  
  // now step the graphics
  [_greedy postStep:dt];
  
  //move the parallax backgrounds
  CGPoint diff = ccpSub(_lastPosition, [_greedy position]);
  
  [((GameScene *)(self.parent)).background setPosition: ccpAdd([((GameScene *)(self.parent)).background position], diff)];
  
  _lastPosition = [_greedy position];
  
  //NSLog(@"Greedy Pos: %f, %f", _lastPosition.x, _lastPosition.y);
  
  //debug speed details after all forces applied and calcualted
  [self SpeedBarUpdate];
  [self moveCameraTo:[_greedy position]];
}

- (void) moveCameraTo:(CGPoint)point
{
  float magnitude = abs(_cameraPosition.y - point.y); //ccpDistance(_cameraPosition, point);
  //NSLog(@"magnitude: %f", magnitude);
  
  if (magnitude > 100) 
  {
    cpVect offset = ccpAngleBetween(_cameraPosition, point);
    float angle = cpvtoangle(offset);
    CGPoint delta = ccpGetOffset(angle, magnitude - 100);
    _cameraPosition = ccpAdd(_cameraPosition, delta);
    
    [self.camera setCenterX:-160 centerY:_cameraPosition.y - 240 centerZ:0];
    [self.camera setEyeX:-160 eyeY:_cameraPosition.y - 240 eyeZ:90];
  }
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