//
//  GreedyGameLayer.m
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 Digital Five. All rights reserved.
//

#import "GameLayer.h"
#import "GameEnvironment.h"
#import "chipmunk.h"
#import "SpaceManager.h"
#import "Asteroid.h"
#import "GDKaosEngine.h"
#import "Background.h"

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
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
	 	_environment = [[GameEnvironment alloc] init];
    
    // asteroids.
    CGSize wins = [[CCDirector sharedDirector] winSize];
    GDKaosEngine *engine = [[GDKaosEngine alloc] initWorldSize:wins withDensity:1.0f];
    
    _asteroids = [[NSMutableArray alloc] init];
    while ([engine hasRoom])
    {
      Asteroid *a = [[Asteroid alloc] initWithEnvironment:_environment 
                                             withPosition:[engine position]];
      [engine addArea:[a area]];
      [self addChild:a];
      [_asteroids addObject:a];
    }

    // greedy!
    _greedy = [[Greedy alloc] initWith:_environment];
    [_greedy setAsteroids:_asteroids];
    [self addChild:_greedy];
    [self runAction:[CCFollow actionWithTarget:_greedy]];
    
		[self schedule: @selector(step:)];
    
    _background = background;
    _lastPosition = [_greedy position];
	}
	return self;
}

- (void) draw
{

}

-(void) step: (ccTime) dt
{
  [_environment step:dt];
  [_greedy step:dt];
  
  CGPoint diff = ccpSub(_lastPosition, [_greedy position]);
  [_background setPosition: ccpAdd([_background position], diff)];
  _lastPosition = [_greedy position];
  
  NSLog(@"diff: (x => %f, y => %f)", diff.x, diff.y);
  
  //float magnitude = ccpDistance(_cameraPosition, [_greedy position]);
  //NSLog(@"magnitude: %f", magnitude);
  //NSLog(@"greedy position: (x => %f, y => %f", 
  //      [_greedy position].x, [_greedy position].y);
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
  static float prevX=0, prevY=0;
  
#define kFilterFactor 0.05f
  
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
  
	prevX = accelX;
	prevY = accelY;
  
  float angle = accelX * 4;
  [_greedy setAngle:angle + (angle * 2)];
  
  //NSLog(@"accelerometer angle: (x => %f, y => %f)", accelX, accelY);
}

@end