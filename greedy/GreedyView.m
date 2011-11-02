//
//  GreedyView.m
//  greedy
//
//  Created by gareth stokes on 1/06/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "GreedyView.h"
#import "cocos2d.h"
#import "chipmunk.h"
#import "Greedy.h"
#import "Explosion.h"
#import "GameObjectCache.h"
#import "GreedyEye.h"
#import "SpriteHelperLoader.h"

@implementation GreedyView

- (float) getEyePositionForCurrentSprite
{
    if (_feeding == kGreedyIdle) return 7.0f;
    if (_feeding == kGreedyEating) return 15.0f;
    return 15.0f;
}

-(void) createSpriteObjects
{
    loaderGreedySprite = [[SpriteHelperLoader alloc] initWithContentOfFile:@"greedysprite"];
    
    spriteFlame = [[loaderGreedySprite spriteWithUniqueName:@"flames_1-hd" atPosition:ccp(0,-35) inLayer:nil] retain];
    [self addChild:spriteFlame z:-1]; 
    
    spriteGreedy = [[loaderGreedySprite spriteWithUniqueName:@"greedy_close_body-hd" atPosition:ccp(0,0) inLayer:nil] retain];
    [self addChild:spriteGreedy];
    
    CCSprite *spriteTemp = [loaderGreedySprite spriteWithUniqueName:@"radar_sweep-hd" atPosition:ccp(0,0) inLayer:nil];
    spriteRadar = [[[Radar alloc] initWithTexture:spriteTemp.texture
                                             rect:spriteTemp.textureRect] retain];
    [self addChild:spriteRadar z:1];
    [self stopRadar];
    
}

- (id) initWithShape:(cpShape *)shape  radar:(cpShape *)radar
{
    CCLOG(@" GreedyView: initWithShape");
    
    CPCCNODE_MEM_VARS_INIT(shape);
    
    if(!(self = [super init])) return nil;
    
    _thrusting = kGreedyThrustNone;
    _feeding = kGreedyIdle;
    
    [self createSpriteObjects];
    
    //Move greedy into layer Greedy so its shape doesn't impact eyeball or background asteroids
    shape->layers = LAYER_GREEDY;

    [self startRadar];
    
    CPCCNODE_SYNC_POS_ROT(self);
    
    return self;
} 

#pragma mark Thrusting

-(void) updateThrustingAnimation
{
    
}

-(void) animationEndedFlameStart:(CCSprite*)sprite
{
    [loaderGreedySprite runAnimationWithUniqueName:@"flameon" onSprite:sprite];
}

-(void) animationEndedFlameStop:(CCSprite*)sprite
{
    [sprite stopAllActions];
}

- (void) setThrusting:(int)value
{
    if (value == kGreedyThrustNone)
    {
        NSLog(@"update thrusting: nil");
        
        [loaderGreedySprite runAnimationWithUniqueName:@"flamestop" 
                                              onSprite:spriteFlame
                                    endNotificationSEL:@selector(animationEndedFlameStop:) 
                                    endNotificationObj:self]; 
         
    }
    
    if (value >= kGreedyThrustLittle)
    {
        NSLog(@"update thrusting: zomg flames!");    
        

        [loaderGreedySprite runAnimationWithUniqueName:@"flamestart" 
                                              onSprite:spriteFlame
                                    endNotificationSEL:@selector(animationEndedFlameStart:) 
                                    endNotificationObj:self]; 
         
    }
    
    _thrusting = value;
    return;
}

- (BOOL) isThrusting
{
    return (_thrusting > 1);
}

- (void) updateFeeding:(int)value
{
    _feeding = value;
    
    if (value == kGreedyIdle)
    {
        NSLog(@"update feeding: idle");
        
        [self closeDown];
        
        return;
    }
    
    if (value >= kGreedyEating)
    {
        NSLog(@"update feeding: eating");
        
        [self openUp];
        
        return;
    }
}

#pragma mark Radar

- (void) startRadar
{
    [spriteRadar setVisible:YES];
    [spriteRadar runAction:[CCRepeatForever actionWithAction:[CCRadarRotateBy actionWithDuration:10.0f angle:360]]];
}

- (BOOL) handleCollisionRadar:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
    NSLog(@"Radar detected asteroid");
    
    return YES;
}

- (void) stopRadar
{
    [spriteRadar setVisible:NO];
}

#pragma mark Greedy Animations
-(void) openUp
{
    CCAction * action = [loaderGreedySprite runAnimationWithUniqueName:@"openup" onSprite:spriteGreedy];
    [spriteGreedy runAction:action];
}

-(void) closeDown
{ 
    CCAction * action = [loaderGreedySprite runAnimationWithUniqueName:@"closedown" onSprite:spriteGreedy];
    [spriteGreedy runAction:action];
}

-(void) wobbleHead:(id)sender
{
    [loaderGreedySprite runAnimationWithUniqueName:@"headwobble" onSprite:spriteGreedy];
}

-(void) goIdle:(id)sender
{

}

-(void) explode
{
    [[[Explosion alloc] initWithPosition:[self position] inLayer:[[GameObjectCache sharedGameObjectCache] gameLayer]] autorelease];
    [self setVisible:NO];
    //disbale shape in world here -TODO
}

#pragma mark Spacemanager helpers

- (void) dealloc
{
	[_implementation release];
    [self removeAllChildrenWithCleanup:YES];
	[super dealloc];
}
-(void)setRotation:(float)rot
{
	if([_implementation setRotation:rot])
		[super setRotation:rot];
}
-(void)setPosition:(cpVect)pos
{
	[_implementation setPosition:pos];
	[super setPosition:pos];
}
-(void) applyImpulse:(cpVect)impulse
{
	[_implementation applyImpulse:impulse offset:cpvzero];
}
-(void) applyForce:(cpVect)force
{
	[_implementation applyForce:force offset:cpvzero];
}
-(void) applyImpulse:(cpVect)impulse offset:(cpVect)offset
{
	[_implementation applyImpulse:impulse offset:offset];
}
-(void) applyForce:(cpVect)force offset:(cpVect)offset
{
	[_implementation applyForce:force offset:offset];
}
-(void) resetForces
{
	[_implementation resetForces];
}
-(void) setIgnoreRotation:(BOOL)ignore
{
	_implementation.ignoreRotation = ignore;
}
-(BOOL) ignoreRotation
{
	return _implementation.ignoreRotation;
}
-(void) setIntegrationDt:(cpFloat)dt
{
	_implementation.integrationDt = dt;
}
-(cpFloat) integrationDt
{
	return _implementation.integrationDt;
}
-(void) setShape:(cpShape*)shape
{
	_implementation.shape = shape;
}
-(cpShape*) shape
{
	return _implementation.shape;
}
-(void) setSpaceManager:(SpaceManager*)spaceManager
{
	_implementation.spaceManager = spaceManager;
}
-(SpaceManager*) spaceManager
{
	return _implementation.spaceManager;
}
-(void) setAutoFreeShape:(BOOL)autoFree
{
	_implementation.autoFreeShape = autoFree;
}
-(BOOL) autoFreeShape
{
	return _implementation.autoFreeShape;
}


@end