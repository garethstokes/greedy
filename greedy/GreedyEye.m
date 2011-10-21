//
//  GreedyEye.m
//  greedy
//
//  Created by Richard Owen on 22/10/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "GreedyEye.h"
#import "GameObjectCache.h"


@implementation GreedyEye

-(void) addEyeContainer:(SpaceManagerCocos2d *)manager shape:(cpShape *) shape
{  
    float segCount = 16.0;
    float segAngle = 360.0 / segCount;
    float radius = 6;
    CGPoint pos = ccp(0,0);
    
    float fromX, fromY = 0.0;
    float toX, toY = 0.0;
    
    for(int seg = 0; seg < segCount; seg++)
    {
        fromX = pos.x + (radius * cos( CC_DEGREES_TO_RADIANS(seg * segAngle) ) );
        fromY = pos.y + (radius * sin( CC_DEGREES_TO_RADIANS(seg * segAngle) ) );
        
        toX = pos.x + (radius * cos( CC_DEGREES_TO_RADIANS((seg + 1) * segAngle )) );
        toY = pos.y + (radius * sin( CC_DEGREES_TO_RADIANS((seg + 1) * segAngle) ) );
        
        _iris[seg] = cpSpaceAddShape([[GameObjectCache sharedGameObjectCache] space], cpSegmentShapeNew(shape->body, cpv(fromX, fromY), cpv(toX, toY), 1.0f));
        
        _iris[seg]->layers = LAYER_EYEBALL;
        _iris[seg]->e = 0.5;
        _iris[seg]->u  = 0.5;
    }
    
    _irisBoundingCircle = cpCircleShapeNew(shape->body, 2.0, ccp(0,0));
    _irisBoundingCircle->sensor = YES;
    _irisBoundingCircle->layers = LAYER_EYEBALL;
    cpSpaceAddShape(manager.space, _irisBoundingCircle);
}

-(id) init
{
    
    if(!(self = [super init])) return nil;
    
    //add crazy eye
    cpShape *sh1 = [[[GameObjectCache sharedGameObjectCache] spaceManager] addCircleAt:ccp(0,0) mass:10.0 radius:3.0];
    sh1->layers = LAYER_EYEBALL;
    cpShapeNode  *_eyeBall = [[cpShapeNode alloc] initWithShape:sh1];
    static const ccColor3B ccGreedyEye = {33,33,33};
    _eyeBall.color = ccGreedyEye;
    [self addChild:_eyeBall];
    [_eyeBall release];
    
    return self;
}

-(void) update:(ccTime) delta
{
    //update the pupil to keep it clamped inside the iris
    CGPoint irisPos =  ((cpCircleShape *)(_irisBoundingCircle))->tc;
    CGPoint pupilPos = self.position;
    
    if(!cpvnear(pupilPos, irisPos, 2.0))
    {
        cpVect dxdy = cpvnormalize_safe(cpvsub(pupilPos, irisPos));	
        CGPoint newPos = cpvadd(irisPos, cpvmult(dxdy, 2.0));
        cpBodySetPos(self.shape->body, newPos);
        cpBodyResetForces(self.shape->body);
    }
    
    //add down force (not a gravity just a "forcy thing")
    cpBodyApplyImpulse(self.shape->body, ccp(0, (-100 * delta)),cpvzero); 
}

@end
