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
#import "WorldRepository.h";
#import "World.h"
#import "GreedyLevel.h"

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

- (void) createFinishLine: (GameEnvironment *) environment  {
    // add event when greedy crosses the finish line. 
      cpShape *finishlineshape = [environment.manager addSegmentAt:ccpAdd([_greedy position], ccp(0, 1600)) fromLocalAnchor:ccp(-150, 0) toLocalAnchor:ccp(150, 0) mass:1 radius:2]; 
    finishlineshape->group = 0;
    finishlineshape->layers = LAYER_FINISHLINE;
    finishlineshape->collision_type = kGreedyFinishLineCollisionType;
    finishlineshape->sensor = YES;
    [environment.manager addCollisionCallbackBetweenType:kGreedyCollisionType 
                                   otherType:kGreedyFinishLineCollisionType
                                      target:self 
                                    selector:@selector(handleCollisionFinishline:arbiter:space:)];

}
- (id) initWithEnvironment:(GameEnvironment *) environment
{
  if( (self=[super init])) {

    
    ACCELORMETER_DIRECTION = 1;
    
    _environment = environment;
    _debugLayer = nil;
    
    WorldRepository *repository = [[[WorldRepository alloc] init] autorelease];
    World *w = [repository findWorldBy:1];
    GreedyLevel *level = [w.levels objectAtIndex:0];
    
    // asteroids.
    int asteroidFieldSize = [level asteroidFieldWidth] * [level asteroidFieldHeight];
    _asteroidField = [[AsteroidField alloc] initWithEnvironment:environment totalArea:asteroidFieldSize density:2.0f Layer:LAYER_ASTEROID];
    [self addChild:_asteroidField];
    
    // static asteroids (big ones!)
    for (int i = 0; i < [level.staticAsteroids count]; i++)
    {
      StaticAsteroidsConfig *config = [level.staticAsteroids objectAtIndex:i];
      Asteroid* staticAsteroid1 = [[Asteroid alloc] initWithEnvironment:environment 
                                                              withLayer:LAYER_ASTEROID 
                                                               withSize:[config size]
                                                           withPosition:[config position]];
      [self addChild:staticAsteroid1];
    }
    
    // greedy!
    _greedy = [[Greedy alloc] initWith:environment startPos:[level greedyPosition]];
    [self addChild:_greedy];
    
    // add limits
    //[environment addTopDownWorldContainmentWithFriction:1.0f elasticity:0.1f height:1800.0 width:350.0];
    [environment addTopDownWorldContainmentWithFriction:[level.environment friction] 
                                             elasticity:[level.environment elasticity] 
                                                 height:[level.environment height]  
                                                  width:[level.environment width] ];
    
    _lastPosition = [_greedy position];
    
    // start and end points
    CCSprite *startPoint = [CCSprite spriteWithFile:@"start_point.png"];
    [startPoint setPosition:ccpAdd([_greedy position], [level startPosition])];
    [self addChild:startPoint z:-1];
    
    _endPoint = [CCSprite spriteWithFile:@"end_point.png"];
    [_endPoint setPosition:ccpAdd([_greedy position], [level finishPosition])];
    [self addChild:_endPoint z:-1];   
    
    [self createFinishLine: environment];

    
    _cameraPosition = ccp(0,0);
    [self moveCameraTo:_lastPosition];
  }
  return self;
}

- (void) startLevel
{
  [_greedy.view  setPosition:ccp(_greedy.view.position.x, _greedy.view.position.y - 250)];
  
  // animate the greedy into view
  [_greedy.view runAction:[CCSequence actions:
                        //[CCFadeOut actionWithDuration:0.25f],
                        //[CCFadeIn actionWithDuration:0.25f],
                        //[CCRotateBy actionWithDuration:2.0f angle:90],
                           [CCMoveBy actionWithDuration:1.5f position:ccp(0, +250)],
                           [CCCallFuncN actionWithTarget:self selector:@selector(startGame:)],
                        nil ] 
   ];
  /*
   [_greedy runAction:[CCSequence actions:
                    [CCDelayTime actionWithDuration:1.4f],
                    [CCFadeOut actionWithDuration:1.1f],
                    nil]
   ];
   */
}

-(void) startGame:(id)sender
{
  [_greedy stopAllActions];
	[self start];
}

- (void) start
{
  [_greedy.view stopAllActions];
  [self schedule: @selector(step:)];
  [_environment.manager start:(1.0/60.0)];
  self.isTouchEnabled = YES;
  self.isAccelerometerEnabled = YES;
}

- (void) pause
{
  
}

- (void) stop
{
  
}

- (void) endLevel
{
  
}

- (BOOL) handleCollisionFinishline:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
  NSLog(@"crossed the finish line");
  CGPoint p = [_endPoint position];
  [self removeChild:_endPoint cleanup:YES];
  _endPoint = [CCSprite spriteWithFile:@"end_point_ready.png"];
  [_endPoint setPosition:p];
  [self addChild:_endPoint z:-1]; 
  
  GameScene * scene = (GameScene*)(self->parent_);
  [scene showScore:_greedy.score time:_timeleft];
  
  return YES;
}

- (void) toggleDebug;
{  
  // debug layer
  if(_debugLayer == nil){
    _debugLayer = [_environment.manager createDebugLayer];
    _debugLayer.visible = YES;
    [self addChild: _debugLayer];
  } else
  {
    [self removeChild:_debugLayer cleanup:YES];
    _debugLayer = nil;
  }
}

- (void) dealloc
{
  NSLog(@"Dealloc GameLayer");
  [ self removeAllChildrenWithCleanup:YES];
  [_asteroidField release];
  [_greedy release];
  [super dealloc];
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
  //[self SpeedBarUpdate];
  [((GameScene *)(_greedy.parent.parent)).hudLayer.lifeMeter setLifeLevel:floor(_greedy.fuel)];
  
  [self moveCameraTo:_lastPosition];
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
  
  [_greedy setAngle:(angle * ACCELORMETER_DIRECTION)];
  
  //NSLog(@"\n angle [%f] accel (x => [%f][%f][%f], y => [%f][%f][%f], z => [%f][%f][%f])", angle, acceleration.x, accelX, angleX, acceleration.y, accelY, angleY, acceleration.z, accelZ, angleZ);
}

- (void) toggleController
{
  if(ACCELORMETER_DIRECTION == -1)
  {
    ACCELORMETER_DIRECTION = 1;
        
  }else{
    ACCELORMETER_DIRECTION = -1;
   
  };
}

@end