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


- (id) initWithEnvironment:(GameEnvironment *) environment level:(int)l
{
    CCLOG(@"GameLayer: initWithEnvironment");
    
    if( (self=[super init])) {
        ACCELORMETER_DIRECTION = [[SettingsManager sharedSettingsManager] getInt:@"controlDirection" withDefault:1] == 0 ? -1 : 1;
        
        _environment = environment;
        _debugLayer = nil;
        
        WorldRepository *repository = [[WorldRepository alloc] init];
            World *w1 = [repository findWorldBy:1];
        [repository release];
        GreedyLevel *level = [w1.levels objectAtIndex:(l - 1)];        
        
        // asteroids.
        int asteroidFieldSize = [level asteroidFieldWidth] * [level asteroidFieldHeight];
        _asteroidField = [[AsteroidField alloc] initWithEnvironment:environment totalArea:asteroidFieldSize density:2.0f Layer:LAYER_ASTEROID];
        [_asteroidField setPosition:ccp(160, 300)];
        [self addChild:_asteroidField];
        [_asteroidField release];
        
        
        // shooters
        _shooters = [[NSMutableArray array] retain];
        for (int i = 0; i < [level.shooters count]; i++)
        {
            ShooterConfig* config = [level.shooters objectAtIndex:i];
            id shooter = [[[AsteroidShooter alloc] initWithEnvironment:environment position:[config position]] autorelease];
            
            [self addChild:shooter];
            [_shooters addObject:shooter];
        }
        
        
        
        
        // static asteroids (big ones!)
        for (int i = 0; i < [level.staticAsteroids count]; i++)
        {
            //StaticAsteroidsConfig *config = [level.staticAsteroids objectAtIndex:i];
//            Asteroid* staticAsteroid1 = [[Asteroid alloc] initWithEnvironment:environment 
//                                                                    withLayer:LAYER_ASTEROID 
//                                                                     withSize:[config size]
//                                                                 withPosition:[config position]];
            
            //Asteroid* staticAsteroid1= [[Asteroid alloc] initWithRadius:[config size] atPosition:[config position]];
            
            //[self addChild:staticAsteroid1];
            //[staticAsteroid1 release];
        }
        
        // add limits
        //[environment addTopDownWorldContainmentWithFriction:1.0f elasticity:0.1f height:1800.0 width:350.0];
        [environment addTopDownWorldContainmentWithFriction:[level.environment friction] 
                                                 elasticity:[level.environment elasticity] 
                                                     height:[level.environment height]  
                                                      width:[level.environment width] ];
        
        _lastPosition = [_greedy position];
        
        // start and end points
        CCSprite *startPoint = [CCSprite spriteWithFile:@"start_point.png"];
        [startPoint setTag:StartTag];
        [startPoint setPosition:ccpAdd([_greedy position], [level startPosition])];
        [self addChild:startPoint z:-1];
        
        _endPoint = [CCSprite spriteWithFile:@"end_point.png"];
        [_endPoint setPosition:ccpAdd([_greedy position], [level finishPosition])];
        [self addChild:_endPoint z:-1];   
        
        [self createFinishLine: environment];
        
        _cameraPosition = ccp(0,0);
        [self moveCameraTo:_lastPosition];
        
        _height = [level.environment height];
        _width = [level.environment width];
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

- (void) startLevel
{
    [[[GameObjectCache sharedGameObjectCache] greedyView] setPosition:ccp([[GameObjectCache sharedGameObjectCache] greedyView].position.x, [[GameObjectCache sharedGameObjectCache] greedyView].position.y - 250)];
    
    // animate the greedy into view
    [[[GameObjectCache sharedGameObjectCache] greedyView] runAction:[CCSequence actions:
                             //[CCFadeOut actionWithDuration:0.25f],
                             //[CCFadeIn actionWithDuration:0.25f],
                             //[CCRotateBy actionWithDuration:2.0f angle:90],
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
    int h = _height /2;
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
    
}

-(void) startGame:(id)sender
{
    [_greedy stopAllActions];
    [_greedy applyThrust];
    
    //switch out the zone
    //[self removeChildByTag:StartTag cleanup:YES];
    
    [self createDeathZone];
    
	[self start];
}

- (void) start
{
    [[[GameObjectCache sharedGameObjectCache] greedyView] stopAllActions];
    
    self.isTouchEnabled = YES;
    self.isAccelerometerEnabled = YES;
    
    [_environment.manager start:(1.0/60.0)];
    [self schedule: @selector(step:)];
}

- (void) pause
{
    
}

- (void) stop
{
    
}

- (void) endLevel
{
    GameScene * scene = (GameScene*)(self->parent_);
    [scene showScore:_greedy.score time:_timeleft];
}


-(void) showScoreCard:(id)sender
{
    GameScene * scene = (GameScene*)(self->parent_);
    [scene showScore:_greedy.score time:_timeleft];
}

- (void) endLevelWithDeath
{
    GameScene * scene = (GameScene*)(self->parent_);
    [scene showDeath];
}

- (BOOL) handleCollisionFinishline:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
    NSLog(@"crossed the finish line");
    CGPoint p = [_endPoint position];
    [self removeChild:_endPoint cleanup:YES];
    _endPoint = [CCSprite spriteWithFile:@"end_point_ready.png"];
    [_endPoint setPosition:p];
    [_endPoint runAction:[CCFadeOut actionWithDuration:3.0f]];
    [self addChild:_endPoint z:-1]; 
    
    CGPoint endPoint = ccp([[GameObjectCache sharedGameObjectCache] greedyView].position.x, [[GameObjectCache sharedGameObjectCache] greedyView].position.y);
    endPoint.x = 0;
    
    [_greedy moveManually:ccpAdd(ccp(0,300), endPoint) target:self selector:@selector(showScoreCard:)];
    
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

-(void) step: (ccTime) dt
{
    // add all the external forces , such as thrusts, asteraid attraction
    [_greedy prestep:dt];
    
    for (id shooter in _shooters)
    {
        [shooter step:dt];
    }
    
    // now step the graphics
    [_greedy postStep:dt];
    
    
    
    //move the parallax backgrounds
    CGPoint diff = ccpSub(_lastPosition, [_greedy position]);
    
    [[[GameObjectCache sharedGameObjectCache] background] setPosition: ccpAdd([[[GameObjectCache sharedGameObjectCache] background] position], diff)];
    
    _lastPosition = [_greedy position];
    
    [[[GameObjectCache sharedGameObjectCache] lifeMeter] setLifeLevel:floor(_greedy.fuel)];
    
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
        [self.camera setEyeX:-160 eyeY:_cameraPosition.y - 240 eyeZ:1.0];
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_greedy removeThrust];
    return;
    
    if ([[[GameObjectCache sharedGameObjectCache] greedyView] isThrusting])
    {
        [_greedy removeThrust];
        return;
    }
    
    [_greedy applyThrust];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_greedy applyThrust];
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
        [[SettingsManager sharedSettingsManager] setValue:@"controlDirection" newInt:1];
        
    }else{
        ACCELORMETER_DIRECTION = -1;
        [[SettingsManager sharedSettingsManager] setValue:@"controlDirection" newInt:0];   
    };
}

- (void) dealloc
{
    NSLog(@"Dealloc GameLayer");
    [_environment.manager stop];
    //[_shooters release];
    //[_greedy release];
    [ self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

@end