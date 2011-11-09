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

-(void) addEyeContainer
{  
    float segCount = 16.0;
    float segAngle = 360.0 / segCount;
    float radius = 6;
    CGPoint pos = ccp(0,0);
    
    float fromX, fromY = 0.0;
    float toX, toY = 0.0;
    
    cpBody *body = cpBodyNewStatic();
    //cpBody *body = cpBodyNew(mass, cpMomentForBox(mass, width, height));
    //cpSpaceAddBody(space, body);
    
    for(int seg = 0; seg < segCount; seg++)
    {
        fromX = pos.x + (radius * cos( CC_DEGREES_TO_RADIANS(seg * segAngle) ) );
        fromY = pos.y + (radius * sin( CC_DEGREES_TO_RADIANS(seg * segAngle) ) );
        
        toX = pos.x + (radius * cos( CC_DEGREES_TO_RADIANS((seg + 1) * segAngle )) );
        toY = pos.y + (radius * sin( CC_DEGREES_TO_RADIANS((seg + 1) * segAngle) ) );
        
        //_iris[seg] = [[[GameObjectCache sharedGameObjectCache] spaceManager] addSegmentAtWorldAnchor:cpv(fromX, fromY) toWorldAnchor:cpv(toX, toY) mass:STATIC_MASS radius:1.0];
        _iris[seg] = cpSpaceAddShape([[GameObjectCache sharedGameObjectCache] space], cpSegmentShapeNew(body, cpv(fromX, fromY), cpv(toX, toY), 1.0f));
        
        
        _iris[seg]->layers = LAYER_EYEBALL;
        _iris[seg]->e = 0.5;
        _iris[seg]->u = 0.5;
        
        if(DEBUG_EYE){
            ccColor3B color = ccc3(rand()%256, rand()%256, rand()%256);
            cpShapeNode *node = [cpShapeNode nodeWithShape:_iris[seg]];
            node.color = color;
            [self addChild:node];
        }
    }
}

-(id) init
{
    
    if(!(self = [super init])) return nil;
    
    [self addEyeContainer];
    
    //    //add crazy eye
    //[[[GameObjectCache sharedGameObjectCache] spaceManager] setGravity:ccp(0, -2)];
    cpShape *shapeEye = [[[GameObjectCache sharedGameObjectCache] spaceManager] addCircleAt:ccp(0,0) mass:2.0 radius:3.0];
    shapeEye->layers = LAYER_EYEBALL;
    
    //Add eyeball
    _eyeBall = [[cpShapeNode alloc] initWithShape:shapeEye];
    static const ccColor3B ccGreedyEye = {33,33,33};
    _eyeBall.color = ccGreedyEye;
    [self addChild:_eyeBall];
    [_eyeBall release];
    
    if(DEBUG_EYE){
        ccColor3B color = ccc3(255, 0, 0);
        cpShapeNode *node = [cpShapeNode nodeWithShape:shapeEye];
        node.color = color;
        [self addChild:node];
    }
    
    [self schedule:@selector(update:)];
    
    return self;
}

-(void) update:(ccTime) delta
{
    //[[GameObjectCache sharedGameObjectCache] spaceManager].rehashStaticEveryStep = YES;
    
    cpvforangle(self.rotation);
    
    
    //add down force (not a gravity just a "forcy thing")
    cpBodyApplyImpulse(_eyeBall.shape->body, cpvforangle(self.parent.rotation), cpvzero); 
}

- (void) dealloc
{
    NSLog(@"Dealloc GreedyEye");
    
    [self removeAllChildrenWithCleanup:YES];
    
    [super dealloc];
}

@end
