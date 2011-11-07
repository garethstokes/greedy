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

-(void) greedyFrameChanged
{
    CCLOG(@"Frame Changed!");
    CGRect rect = [[spriteGreedy displayedFrame] rectInPixels];
    
    [spriteFlame setPosition:ccp(0, -(rect.size.height / 2.0f) - 8)]; //magic numbers woot!
}

-(void) createSpriteObjects
{
    loaderGreedySprite = [[SpriteHelperLoader alloc] initWithContentOfFile:@"greedysprite"];
    
    spriteFlame = [[loaderGreedySprite spriteWithUniqueName:@"flames_1-hd" atPosition:ccp(0,-35) inLayer:nil] retain];
    [self addChild:spriteFlame z:-1]; 
    
    spriteGreedy = [[loaderGreedySprite spriteWithUniqueName:@"greedy_close_body-hd" atPosition:ccp(0,0) inLayer:nil] retain];
    [spriteGreedy setCallback:self sel:@selector(greedyFrameChanged)];
    [self addChild:spriteGreedy];    
}

- (id) initWithShape:(cpShape *)shape
{
    CCLOG(@" GreedyView: initWithShape");
    
    CPCCNODE_MEM_VARS_INIT(shape);
    
    if(!(self = [super init])) return nil;
    
    _thrusting = kGreedyThrustNone;
    _feeding = kGreedyIdle;
    _eatCount = 0;
    
    [self createSpriteObjects];
    
    //Move greedy into layer Greedy so its shape doesn't impact eyeball or background asteroids
    shape->layers = LAYER_GREEDY;
    
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

-(void) incrementEating
{
    if(_eatCount == 0){
        [self openUp];
         NSLog(@"update feeding: eating");
    }
    _eatCount++;
    
    NSLog(@"Inc eat: %d", _eatCount);
    
}

-(void) decrementEating
{
    _eatCount--;
    if(_eatCount == 0)
    {
        [self closeDown];
         NSLog(@"update feeding: idle");
    }
    NSLog(@"Dec eat: %d", _eatCount);
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