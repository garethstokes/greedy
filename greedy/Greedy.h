//
//  Greedy.h
//  greedy
//
//  Created by gareth stokes on 7/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "GameObject.h"
#import "cocos2d.h"
#import "chipmunk.h"
#import "GameEnvironment.h"
#import "Asteroid.h"
#import "GreedyView.h"

enum {
	kGreedyOpen1 = 1,
 	kGreedyOpen2 = 2,
    kGreedyOpen3 = 3,
    kGreedyOpen4 = 4,
    kGreedyOpen5 = 5
};

typedef enum {
    kGreedyIdle = 1,
    kGreedyExcited = 2,
    kGreedyDetectedFood = 3,
    kGreedyEating = 4
} GREEDYSTATE;

enum {
    kGreedyThrustNone = 1,
    kGreedyThrustLittle = 2,
    kGreedyThrustMassive = 3
};

@interface Greedy : CCNode {
    cpShape *_shape;
    
    Radar* spriteRadar;
    
    cpFloat _angle;
        
    float _score;
    float _fuel;
    BOOL  _exploded;
    CGPoint explosionPoint;
}

@property (nonatomic) cpShape *shape;
@property (nonatomic) float score;
@property (nonatomic, assign) float fuel;

- (id) initWith:(GameEnvironment *)environment startPos:(cpVect)startPos;
- (void) prestep:(ccTime) delta;
- (void) applyThrust;
- (void) removeThrust;
- (void) setAngle:(cpFloat)value;
- (BOOL) hasExploded;
- (void) explode;
-(float) score;
- (void) moveManually:(CGPoint)point target:(id)t selector:(SEL) s;
-(void) start;

//Collision
- (BOOL) handleCollisionWithAsteroid:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;


@end
