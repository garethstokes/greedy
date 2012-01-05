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
#import "GameObjectCache.h"
#import "SimpleAudioEngine.h"

@implementation Greedy
@synthesize shape = _shape;
@synthesize score = _score;
@synthesize fuel = _fuel;


- (id) initWith:(GameEnvironment *)environment startPos:(cpVect)startPos
{
    CCLOG(@" Greedy: initWith");
    
    if(!(self = [super init])) return nil;
    
  cpShape *shape = [sharedSpaceManager
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
    cpBodySetVelLimit(body, 120);
    body->data = self;
    
    _shape = shape;
    
    _fuel = 10;
    
    _exploded = NO;
    
    
    //init collisions
	[sharedSpaceManager  addCollisionCallbackBetweenType: kAsteroidCollisionType 
                                                                                   otherType: kGreedyCollisionType 
                                                                                      target: self 
                                                                                    selector: @selector(handleCollisionWithAsteroid:arbiter:space:)];
    
    // view
    GreedyView *aview = [[GreedyView alloc] initWithShape:shape];
    [[GameObjectCache sharedGameObjectCache] addGreedyView:aview];
    [self addChild:aview];
    [aview release];
    
    //Radar    
  _spriteRadar = [[[Radar alloc] initWithBody:body] autorelease];
  [self addChild:_spriteRadar z:100];
    
    _lastCollideTime = [NSDate timeIntervalSinceReferenceDate];
    
    return self;
}

-(void) start
{
  [_spriteRadar start];
}

static void explodeGreedy(cpSpace *space, void *obj, void *data)
{
	[(Greedy*)(obj) explode];
}

- (BOOL) handleCollisionWithAsteroid:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
    if (_exploded) return YES;
        
	if (moment == COLLISION_BEGIN)
	{
		//NSLog(@"You hit an asteroid!!!");
        
        CP_ARBITER_GET_SHAPES(arb,a,b);

        double collideTime = [NSDate timeIntervalSinceReferenceDate];
        if ((collideTime - _lastCollideTime) < 1.5) return YES;
        
        // BAMM SOUND~!!
        [[SimpleAudioEngine sharedEngine] playEffect:@"collision_dc_small.mp3" pitch:1 pan:1 gain:0.2];
        
        cpVect p = cpArbiterGetPoint(arb, 0);
        CCParticleSystemQuad *puff = [CCParticleSystemQuad particleWithFile:@"AsteroidPuff.plist"];
        
        [puff setPosition:p];
        [puff setDuration:2.0];
        [self addChild:puff];
        
        float bumpStrength = cpArbiterGetDepth(arb, 0) * -1; //0.1;
        bumpStrength = bumpStrength * 0.8;
        bumpStrength = bumpStrength > 0.5 ? 0.5 : bumpStrength;
        
        //reduce the fuel
        if ((bumpStrength >= 0.020) && (_fuel > 0.0))
        {
#define FUELBUMP 1
            //CCLOG(@"Asteroid Bump %f", bumpStrength);
            _fuel -= (FUELBUMP * bumpStrength);
            if (_fuel < 0.0){
                cpSpaceAddPostStepCallback(sharedSpace, explodeGreedy, sharedGreedy, self);
              //[self explode];
            }
        }
	}
    
	return YES;
}

- (void) burnFuel:(float)amount
{
    if(_fuel > 0.0){
        _fuel -= amount;
        if (_fuel < 0.0){
            [self removeThrust];
            _fuel = 0.0;
            
            //schedule post solve perhaps?
            cpSpaceAddPostStepCallback(sharedSpace, explodeGreedy, sharedGreedy, self);

            //[self explode];
        }
    }
}

- (void) explode
{
    if(!_exploded)
    {
    [_spriteRadar stop];
        
    [sharedGreedyView explode];
        
        //[[[GameObjectCache sharedGameObjectCache] spaceManager] removeAndFreeShape:_shape];
        //remove all thrusts
        cpBodyResetForces(_shape->body);
        explosionPoint = _shape->body->p;
        
        [self.parent schedule:@selector(endLevelWithDeath) interval:3.0f];
    }
    _exploded = YES;
}

- (void) prestep:(ccTime) delta
{
    //CCLOG(@"Greedy prestep");
    
    if(!_exploded){
        //set angle of greedy
        cpBodySetAngle(_shape->body, CC_DEGREES_TO_RADIANS(_angle));
        
        //Rotate the Radar
        [_spriteRadar step:delta];
        
        if ([sharedGreedyView isThrusting])
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
            //NSLog(@"greedy velocity: %d", abs(velocity.y));
            
            if (abs(velocity.y) > 5)
            {
                //add down force (not a gravity just a "forcy thing")
                cpBodyApplyImpulse(_shape->body, ccp(0, (GREEDYTHRUST/1.0f * delta) * -1),cpvzero);
            }
        }
    } else{
        cpBodyResetForces(_shape->body);
    }
}

- (void) applyThrust
{
    if(!_exploded){
        //if ([_view removingThrust]) return;
        
        if (_fuel <= 0.0) return;
        
        //NSLog(@"applying thrust...");
        [sharedGreedyView setThrusting:kGreedyThrustLittle];
    }
}

- (void) removeThrust
{
    //NSLog(@"removing thrust...");
    if(!_exploded)
        [sharedGreedyView setThrusting:kGreedyThrustNone];
}

- (CGPoint) position
{
    if(!_exploded)
    {
        cpBody *body = _shape->body;
        return body->p;
    } else {
        return explosionPoint;
    }
}

- (void) setAngle:(cpFloat)value
{
    _angle = value;
}

- (BOOL) hasExploded
{
    return _exploded;
}

- (void) moveManually:(CGPoint)point target:(id)t selector:(SEL)s
{
  [sharedGreedyView setThrusting:kGreedyThrustNone];
    
  [sharedGreedyView runAction:[CCSequence actions:
                                                                     [CCMoveBy actionWithDuration:3.0f position:point],
                                                                     [CCCallFuncN actionWithTarget:t selector:s],
                                                                     nil ]];
}

-(float) score
{
  return _spriteRadar.score;
}

- (void)dealloc
{
    CCLOG(@"Dealloc Greedy");
  
    [self removeAllChildrenWithCleanup:YES];
  
    [super dealloc];
}

@end
