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

@implementation Greedy
@synthesize shape = _shape;
@synthesize score = _score;
@synthesize fuel = _fuel;


- (id) initWith:(GameEnvironment *)environment startPos:(cpVect)startPos
{
    CCLOG(@" Greedy: initWith");
    
    if(!(self = [super init])) return nil;
    
    cpShape *shape = [[[GameObjectCache sharedGameObjectCache] spaceManager] 
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
    
    _shape = shape;
    
    _fuel = 10;
    
    _exploded = NO;
    
    
    //init collisions
	[[[GameObjectCache sharedGameObjectCache] spaceManager]  addCollisionCallbackBetweenType: kAsteroidCollisionType 
                                                                                   otherType: kGreedyCollisionType 
                                                                                      target: self 
                                                                                    selector: @selector(handleCollisionWithAsteroid:arbiter:space:)];
    
    
    // view
    GreedyView *aview = [[GreedyView alloc] initWithShape:shape];
    [[GameObjectCache sharedGameObjectCache] addGreedyView:aview];
    [self addChild:aview];
    [aview release];
    
    //Radar    
    spriteRadar = [[[Radar alloc] initWithBody:body] retain];
    [self addChild:spriteRadar z:100];
    [spriteRadar stop];
    
    return self;
}

-(void) start
{
    [spriteRadar start];
}


- (BOOL) handleCollisionWithAsteroid:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
  if (_exploded) return YES;
    
	if (moment == COLLISION_POSTSOLVE)
	{
		NSLog(@"You hit an asteroid!!!");
        
        CP_ARBITER_GET_SHAPES(arb,a,b);
        
        //cpVect p = cpArbiterGetPoint(arb, 0);
        
        //CCParticleSystemQuad *puff = [CCParticleSystemQuad particleWithFile:@"AsteroidPuff.plist"];
        
        //[puff setPosition:p];
        //[puff setDuration:2.0];
        //[self addChild:puff];
        
        float bumpStrength = 0.032; //cpvlength(cpArbiterTotalImpulse(arb)) / 100;
        
        //reduce the fuel
        if ((bumpStrength >= 0.020) && (_fuel > 0.0))
        {
#define FUELBUMP 1
            CCLOG(@"Asteroid Bump %f", bumpStrength);
            _fuel -= (FUELBUMP * bumpStrength);
            if (_fuel < 0.0){
              [self explode];
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
            [self explode];
        }
    }
}

- (void) explode
{
    if(!_exploded)
    {
        [spriteRadar stop];
        
        [[[GameObjectCache sharedGameObjectCache] greedyView] explode];
        
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
        [spriteRadar step:delta];
        
        if ([[[GameObjectCache sharedGameObjectCache] greedyView] isThrusting])
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
        
        NSLog(@"applying thrust...");
        
        [[[GameObjectCache sharedGameObjectCache] greedyView] setThrusting:kGreedyThrustLittle];
    }
}

- (void) removeThrust
{
    NSLog(@"removing thrust...");
    if(!_exploded)
        [[[GameObjectCache sharedGameObjectCache] greedyView] setThrusting:kGreedyThrustNone];
    else {
    }
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
    [[[GameObjectCache sharedGameObjectCache] greedyView] setThrusting:kGreedyThrustNone];
    
    [[[GameObjectCache sharedGameObjectCache] greedyView] runAction:[CCSequence actions:
                                                                     [CCMoveBy actionWithDuration:3.0f position:point],
                                                                     [CCCallFuncN actionWithTarget:t selector:s],
                                                                     nil ]];
}

-(float) score
{
    return spriteRadar.score;
}

- (void)dealloc
{
    CCLOG(@"Dealloc Greedy");
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

@end