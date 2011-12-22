//
//  Radar.m
//  greedy
//
//  Created by Richard Owen on 29/10/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "Radar.h"
#import "GameObjectCache.h"
#import "SimpleAudioEngine.h"
#import "OreAnimation.h"

@implementation Radar

- (void) addRadarCircumferanceSensor: (cpBody *) body {
  //Add radar
  //Add the Radar sensor
  _shapeRadarCircle = cpCircleShapeNew(body, 120.0, cpvzero);  
  _shapeRadarCircle->e = .5; 
	_shapeRadarCircle->u = .5;
  _shapeRadarCircle->group = 0;
  _shapeRadarCircle->layers = LAYER_RADAR;
	_shapeRadarCircle->collision_type = kGreedyRadarCollisionType;
  _shapeRadarCircle->sensor = YES;
	_shapeRadarCircle->data = nil;
  
  cpSpaceAddShape(sharedSpace, _shapeRadarCircle);
  
  [sharedSpaceManager addCollisionCallbackBetweenType: kGreedyRadarCollisionType
                                            otherType: kAsteroidCollisionType 
                                               target: self 
                                             selector: @selector(handleCollisionRadar:arbiter:space:)]; 
}

-(float) score
{
  return _score;
}

- (void) createRadarLine: (cpBody *) body
{
  if(_radarShape == nil)
  {
    _radarShape = [sharedSpaceManager addSegmentAt:body->p fromLocalAnchor:ccp(0,0) toLocalAnchor:ccp(130, 0) mass:1.0 radius:2.0];
    _radarShape->sensor = YES;
    _radarShape->layers = LAYER_RADARLINE;
    _radarShape->collision_type = kGreedyRadarlineCollisionType;
    
    _radarPin = [sharedSpaceManager addPinToBody:body fromBody:_radarShape->body toBodyAnchor:ccp(0,0) fromBodyAnchor:ccp(0,0)];
    
    [sharedSpaceManager addCollisionCallbackBetweenType: kGreedyRadarlineCollisionType
                                              otherType: kAsteroidCollisionType 
                                                 target: self 
                                               selector: @selector(handleCollisionRadarLine:arbiter:space:)];
  }
}

-(id) initWithBody:(cpBody*)body
{     
  
  self = [super initWithFile:@"radio_sweep.png"];
  
  [self addRadarCircumferanceSensor: body];
  
  [self createRadarLine: body];
  
  [self setVisible:NO];
  
  CPCCNODE_MEM_VARS_INIT(_radarShape);
  
  CPCCNODE_SYNC_POS_ROT(self);
  
  return self;
}

- (void) stop
{
  [self setVisible:NO];
  
  //remove from simulation
  cpSpaceRemoveShape(sharedSpace, _shapeRadarCircle);
  cpSpaceRemoveShape(sharedSpace, _radarShape);
}

- (void) start
{
  [self setVisible:YES];
}

- (BOOL) handleCollisionRadar:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	if (moment == COLLISION_BEGIN)
	{
		CCLOG(@"You are within radar range... woot!!!");
    
    [[[GameObjectCache sharedGameObjectCache] greedyView] incrementEating];
	}
  
  if (moment == COLLISION_SEPARATE)
  {
    CCLOG(@"You are no longer in radar range... :( !!!");
    
    [[[GameObjectCache sharedGameObjectCache] greedyView] decrementEating];
  }
  
	return YES;
}

- (void)addGoldCollectionAnimation:(cpArbiter *)arb
{
  //CCParticleSystemQuad *sparkle = [CCParticleSystemQuad particleWithFile:@"sparkle.plist"];
  //[sparkle setPosition:cpArbiterGetPoint(arb, 0)];
  //[sparkle setDuration:0.1];
  //[[[GameObjectCache sharedGameObjectCache] gameLayer] addChild:sparkle];
}

- (BOOL) handleCollisionRadarLine:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	//if (_exploded) return YES;
  
  if (moment == COLLISION_BEGIN)
	{
    CCLOG(@"Line Meets asteroid begin");
    
    CP_ARBITER_GET_SHAPES(arb, a, b);
    Asteroid * ast = (Asteroid *)(b->data);
    cpFloat len = cpArbiterGetDepth(arb, 0);
    
    if([ast isKindOfClass:[Asteroid class]]){
      float oreScore = [ast mineOre:1.0 length:len];
      
      if( oreScore > 0)
      { 
        _score += oreScore;
        
        //[self addGoldCollectionAnimation:arb];
        
        [ast setOreAnim:[[[OreAnimation alloc] initWithPosition:cpArbiterGetPoint(arb, 0)] autorelease]];
        
        [[ast oreAnim] addScore:oreScore];
        
        if((arc4random() % 100) <= 10)
          [[SimpleAudioEngine sharedEngine] playEffect:@"greedy_laugh.mp3" pitch:1 pan:1 gain:0.2];
        else
          [[SimpleAudioEngine sharedEngine] playEffect:@"gold_small.mp3" pitch:1 pan:1 gain:0.2];
        
      }
    }
  }
  
  if (moment == COLLISION_PRESOLVE)
	{
    CCLOG(@"Line Meets asteroid post solve");
    CP_ARBITER_GET_SHAPES(arb, a, b);
    int size = cpArbiterGetCount(arb) - 1;
    
    Asteroid * ast = (Asteroid *)(b->data);
    cpFloat len = cpArbiterGetDepth(arb, size);
    
    if([ast isKindOfClass:[Asteroid class]]){
      
      float oreScore = [ast mineOre:1.0 length:len];
      
      if( oreScore > 0)
      { 
        _score += oreScore;
        
        [[ast oreAnim] addScore:oreScore];
        
        for(int i = 0; i < size+1;i++){
          CCLOG(@"Asteroid Collision Details: i:%d size:%d point:%f,%f", i, size, cpArbiterGetPoint(arb, i).x, cpArbiterGetPoint(arb, i).y);
          [[ast oreAnim] addPoint:cpArbiterGetPoint(arb, i)];
        }
      }
    }
  }
  
  if (moment == COLLISION_SEPARATE)
  {
    CCLOG(@"Line Leaves asteroid end");
    CP_ARBITER_GET_SHAPES(arb, a, b);
    Asteroid * ast = (Asteroid *)(b->data);
    
    if([ast isKindOfClass:[Asteroid class]]){
      [[ast oreAnim] endAnimation];
    };
  }
  
  return YES;
}

-(void) step:(ccTime) delta
{
  static cpFloat ONEDEGREE = CC_DEGREES_TO_RADIANS(1);
  cpBodySetAngle(_radarShape->body, _radarShape->body->a - (ONEDEGREE * RADAR_SPIN_DEGREES_PER_SECOND) * delta);
}

CPCCNODE_FUNC_SRC;

@end
