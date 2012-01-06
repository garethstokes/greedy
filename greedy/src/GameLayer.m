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
#import "WorldRepository.h"
#import "World.h"
#import "GreedyLevel.h"
#import "SettingsManager.h"
#import "AccelerometerSimulation.h"
#import "AsteroidShooter.h"
#import "GameObjectCache.h"

enum SpriteTags{
  StartTag = 0
};

@implementation GameLayer

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


- (void)addStartLine:(GreedyLevel *)level
{
  // start and end points
  CCSprite *startPoint = [CCSprite spriteWithFile:@"start_point.png"];
  [startPoint setTag:StartTag];
  [startPoint setPosition:ccpAdd([sharedGreedy position], [level startPosition])];
  [self addChild:startPoint z:-1];
}

- (void)addFinishLine:(GreedyLevel *)level environment:(GameEnvironment *)environment
{
  _endPoint = [CCSprite spriteWithFile:@"end_point.png"];
  [_endPoint setPosition:ccpAdd([sharedGreedy position], [level finishPosition])];
  [self addChild:_endPoint z:-1];   
  
  [self createFinishLine: environment at:[level finishPosition]];
}

- (id) initWithEnvironment:(GameEnvironment *) environment level:(int)l
{
  CCLOG(@"GameLayer: initWithEnvironment");
  
  if( (self=[super init])) {
    ACCELORMETER_DIRECTION = [[SettingsManager sharedSettingsManager] getInt:@"controlDirection" withDefault:1] == 0 ? -1 : 1;
    
    _debugLayer = nil;
    
    WorldRepository *repository = [[WorldRepository alloc] init];
    World *w1 = [repository findWorldBy:1];
    [repository release];
    GreedyLevel *level = [w1.levels objectAtIndex:(l - 1)];        
    
    // asteroids.
    _asteroidField = [[AsteroidField alloc] initWithSize:CGSizeMake([level asteroidFieldWidth], [level asteroidFieldHeight]) density:2.0f Layer:LAYER_ASTEROID];
    [_asteroidField setPositionInPixels:ccp(0,0)];
    [self addChild:_asteroidField];
    [_asteroidField release];
    
    
    // shooters
    _shooters = [[NSMutableArray array] retain];
    for (int i = 0; i < [level.shooters count]; i++)
    {
      ShooterConfig* config = [level.shooters objectAtIndex:i];
      id shooter = [[[AsteroidShooter alloc] initWithAsteroidField:_asteroidField position:[config position]] autorelease];
      
      [self addChild:shooter];
      [_shooters addObject:shooter];
    }
    
    // static asteroids (big ones!)
    for (int i = 0; i < [level.staticAsteroids count]; i++)
    {
      StaticAsteroidsConfig *config = [level.staticAsteroids objectAtIndex:i];
      [_asteroidField addAsteroid:[config position] size:[config size]];    
    }
    
    // greedy!
    Greedy *_greedy = [[Greedy alloc] initWith:environment startPos:[level greedyPosition]];
    [_greedy setFuel:[level fuel]];
    [self addChild:_greedy];
    [[GameObjectCache sharedGameObjectCache] addGreedy:_greedy];
    [_greedy release];
    
    // add limits
    //[environment addTopDownWorldContainmentWithFriction:1.0f elasticity:0.1f height:1800.0 width:350.0];
    [environment addTopDownWorldContainmentWithFriction:[level.environment friction] 
                                             elasticity:[level.environment elasticity] 
                                                 height:[level.environment height]  
                                                  width:[level.environment width] ];
    
    _lastPosition = [_greedy position];
    
    [self addStartLine:level];
    
    [self addFinishLine:level environment:environment];
    
    _cameraPosition = ccp(0,0);
    [self moveCameraTo:_lastPosition];
    
    _height = [level.environment height];
    _width = [level.environment width];
      
    // log settings for fun a profit
    [[SettingsManager sharedSettingsManager] logSettings];
  }
  return self;
}

- (void) createFinishLine: (GameEnvironment *) environment at:(CGPoint)p {
  // add event when greedy crosses the finish line. 
  cpShape *finishlineshape = [sharedSpaceManager 
                              addSegmentAt:ccpAdd([sharedGreedy position], p) 
                              fromLocalAnchor:ccp(-150, 0) 
                              toLocalAnchor:ccp(150, 0) mass:1 radius:2]; 
  finishlineshape->group = 0;
  finishlineshape->layers = LAYER_FINISHLINE;
  finishlineshape->collision_type = kGreedyFinishLineCollisionType;
  finishlineshape->sensor = YES;
  [sharedSpaceManager addCollisionCallbackBetweenType:kGreedyCollisionType 
                                            otherType:kGreedyFinishLineCollisionType
                                               target:self 
                                             selector:@selector(handleCollisionFinishline:arbiter:space:)];
  
}

- (void) startLevel
{
  _followGreedy = YES;
  int x = sharedGreedyView.position.x;
  int y = sharedGreedyView.position.y - 250;
  
  [sharedGreedyView setPosition:ccp(x, y)];
  
  // animate the greedy into view
  [sharedGreedyView runAction:[CCSequence actions:
                               [CCMoveBy actionWithDuration:1.5f position:ccp(0, +250)],
                               [CCCallFuncN actionWithTarget:self selector:@selector(startGame:)],
                               nil ] 
   ];
}

- (void) createDeathZone {
  //load in the master files ... ie the PNG and zwoptex plist
  _batchDeath = [CCSpriteBatchNode batchNodeWithFile:@"start_death.png" capacity:2]; 
  [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"start_death.plist"]; 
  
  //Body
  CCSprite *spriteDeath = [CCSprite spriteWithSpriteFrameName:@"start_death.png"];
  int h = _height / 2;
  [spriteDeath setPosition:ccp(0, (0 - h))];
  [_batchDeath addChild:spriteDeath];
  
  //Create death zone
  NSMutableArray *deathFrames = [NSMutableArray array];
  
  [deathFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"start_death.png"]];
  [deathFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"start_death_2.png"]];
  
  CCAnimation *animationDeath = [CCAnimation animationWithFrames:deathFrames delay:1.0f];
  _actionDeath = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animationDeath]];
  
  [spriteDeath runAction:_actionDeath];
  
  [self addChild:_batchDeath z:-1];
  cpShape *deathzoneshape = [sharedSpaceManager addRectAt:ccp(0, (0 - h)) mass:1 width:_width height:10 rotation:0]; 
  deathzoneshape->group = 0;
  deathzoneshape->layers = LAYER_FINISHLINE;
  deathzoneshape->collision_type = kGreedyDeathZoneCollisionType;
  deathzoneshape->sensor = YES;
  
  
  [sharedSpaceManager addCollisionCallbackBetweenType:kGreedyCollisionType 
                                            otherType:kGreedyDeathZoneCollisionType
                                               target:self 
                                             selector:@selector(handleCollisionDeathZone:arbiter:space:)];
  
}

-(void) startGame:(id)sender
{
  [sharedGreedy stopAllActions];
  
  [sharedGreedy applyThrust];
  
  [sharedGreedy start];
  
  [self createDeathZone];
  
	[self start];
}

- (void) start
{
  [sharedGreedyView stopAllActions];
  
  self.isTouchEnabled = YES;
  self.isAccelerometerEnabled = YES;
  
  [sharedSpaceManager start:(1.0/60.0)];
  [self schedule: @selector(step:) interval:(1.0/60.0)];
}

- (void) pause
{
  [sharedSpaceManager stop];
  [self unschedule: @selector(step:)];    
}

- (void) stop
{
  [sharedSpaceManager stop];
  [self unschedule: @selector(step:)]; 
}

- (void) endLevel
{
  [sharedGameScene showScore:sharedGreedy.score time:_timeleft];
}


-(void) showScoreCard:(id)sender
{
  [sharedGameScene showScore:sharedGreedy.score time:_timeleft];
  [sharedGameScene removeHud];
}

- (void) endLevelWithDeath
{
  [sharedGameScene showDeath];
}

- (BOOL) handleCollisionFinishline:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
  
  NSLog(@"crossed the finish line");
  
  if (moment == COLLISION_BEGIN)
  {
    CGPoint p = [_endPoint position];
    [self removeChild:_endPoint cleanup:YES];
    _endPoint = [CCSprite spriteWithFile:@"end_point_ready.png"];
    [_endPoint setPosition:p];
    [_endPoint runAction:[CCFadeOut actionWithDuration:3.0f]];
    [self addChild:_endPoint z:-1]; 
    
    [[sharedGameScene hudLayer] stop];
    
    CGPoint endPoint = ccp(sharedGreedyView.position.x, sharedGreedyView.position.y);
    endPoint.x = 0;
    
    _followGreedy = NO;
    [sharedGreedy isInvincible]; 
    [sharedGreedy moveManually:ccpAdd(ccp(0,200), endPoint) target:self selector:@selector(showScoreCard:)];
  }
  
  return YES;
}

static void explodeGreedy(cpSpace *space, void *obj, void *data)
{
	[(Greedy*)(obj) explode];
}

- (BOOL) handleCollisionDeathZone:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
  if (moment == COLLISION_BEGIN)
	{
    NSLog(@"Contacted Death Zone");
    
    //add a post solve explosion ka bluweee!
    
    cpSpaceAddPostStepCallback(sharedSpace, explodeGreedy, sharedGreedy, self);
  }
  return YES;
}

- (void) toggleDebug;
{  
  // debug layer
  if(_debugLayer == nil){
    _debugLayer = [sharedSpaceManager createDebugLayer];
    _debugLayer.visible = YES;
    [self addChild: _debugLayer];
  } else
  {
    [self removeChild:_debugLayer cleanup:YES];
    _debugLayer = nil;
  }
}

-(void) step: (ccTime) dt
{
  //CCLOG(@"GameLayer step");
  
  // add all the external forces , such as thrusts, asteraid attraction
  [sharedGreedy prestep:dt];
  
  for (id shooter in _shooters)
  {
    [shooter step:dt];
  }
  
  
  //Update fuel level
  [[[GameObjectCache sharedGameObjectCache] lifeMeter] setLifeLevel:floor(sharedGreedy.fuel)];
  
  if (_followGreedy){
    
    //move the parallax backgrounds
    CGPoint diff = ccpSub(_lastPosition, [sharedGreedy position]);
    [sharedBackground setPosition: ccpAdd([sharedBackground position], diff)];
    
    //update camera position
    _lastPosition = [sharedGreedy position];
    [self moveCameraTo:_lastPosition];
  }
}

- (void) moveCameraTo:(CGPoint)point
{
  float magnitude = abs(_cameraPosition.y - point.y); 
  
  if (magnitude > 100) 
  {
    cpVect offset = ccpAngleBetween(_cameraPosition, point);
    float angle = cpvtoangle(offset);
    CGPoint delta = ccpGetOffset(angle, magnitude - 100);
    _cameraPosition = ccpAdd(_cameraPosition, delta);
    
    [self.camera setCenterX:-160 centerY:_cameraPosition.y - 240 centerZ:0];
    [self.camera setEyeX:-160 eyeY:_cameraPosition.y - 240 eyeZ:1.0];
  }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [sharedGreedy removeThrust];
  return;
  
  if ([sharedGreedyView isThrusting])
  {
    [sharedGreedy removeThrust];
    return;
  }
  
  [sharedGreedy applyThrust];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [sharedGreedy applyThrust];
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
  
  [sharedGreedy setAngle:(angle * ACCELORMETER_DIRECTION)];
  
  //NSLog(@"\n angle [%f] accel (x => [%f][%f][%f], y => [%f][%f][%f], z => [%f][%f][%f])", angle, acceleration.x, accelX, angleX, acceleration.y, accelY, angleY, acceleration.z, accelZ, angleZ);
}

- (void) toggleController
{
  if(ACCELORMETER_DIRECTION == -1)
  {
    ACCELORMETER_DIRECTION = 1;
    [[SettingsManager sharedSettingsManager] setValue:@"controlDirection" newInt:1];
    
  }else{
    ACCELORMETER_DIRECTION = -1;
    [[SettingsManager sharedSettingsManager] setValue:@"controlDirection" newInt:0];   
  };
}

- (void) dealloc
{
  NSLog(@"Dealloc GameLayer");
  [self stop];
  [self removeAllChildrenWithCleanup:YES];
  [super dealloc];
}

@end
