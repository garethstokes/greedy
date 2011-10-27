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



- (void) createSprites
{
    //load in the masters files ... ie the PNG and zwoptex plist
    _batch = [CCSpriteBatchNode batchNodeWithFile:@"greedy.png" capacity:15]; 
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"greedy.plist"]; 
    
    
    //Create sequences
    
    
    //flame
    NSMutableArray *flameFrames = [NSMutableArray array];
    [flameFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"flames_3.png"]];
    [flameFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"flames_4.png"]];
    [flameFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"flames_5.png"]];
    [flameFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"flames_6.png"]];
    [flameFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"flames_7.png"]];
    
    CCAnimation *animation = [CCAnimation animationWithFrames:flameFrames delay:0.1f];
    [[CCAnimationCache sharedAnimationCache] addAnimation:animation name:@"flames"];
    _actionFlame = [CCAnimate actionWithDuration:0.1 animation:[[CCAnimationCache sharedAnimationCache] animationByName:@"flames"] restoreOriginalFrame:NO];
    
    //openUp
    NSMutableArray *_aryOpenUp = [NSMutableArray array];
    [_aryOpenUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_1.png"]];
    [_aryOpenUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_2.png"]];
    [_aryOpenUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_3.png"]];
    [_aryOpenUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_4.png"]];
    [_aryOpenUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_5.png"]];
    
    _animationOpenUp = [CCAnimation animationWithFrames:_aryOpenUp];
    _actionOpenUp    = [[CCAnimate actionWithDuration:0.05 animation:_animationOpenUp restoreOriginalFrame:NO] retain];
    
    //closeDown
    _actionCloseDown = [[_actionOpenUp reverse] retain];
    [_actionCloseDown setDuration:0.2];
    
    //head wobble open
    NSMutableArray *wobbleFrames = [NSMutableArray array];
    
    [wobbleFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_5_offset_a.png"]];
    [wobbleFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_open_5_offset_b.png"]];
    
    CCAnimation *animationWobble = [CCAnimation animationWithFrames:wobbleFrames delay:0.1f];
    _actionWobble = [[CCRepeatForever actionWithAction:[CCAnimate actionWithDuration:0.2 animation:animationWobble restoreOriginalFrame:NO]] retain];
    
    
}

-(void) createSpriteObjects
{
    loaderGreedySprite = [[SpriteHelperLoader alloc] initWithContentOfFile:@"greedysprite"];
    
    //[loader spriteWithUniqueName:@"flamestart" atPosition:CGPointZero inLayer:[[GameObjectCache sharedGameObjectCache] gameLayer]];
    
    [loaderGreedySprite release];
}

- (id) initWithShape:(cpShape *)shape  radar:(cpShape *)radar
{
    CCLOG(@" GreedyView: initWithShape");
    
    if(!(self = [super init])) return nil;
    
    _shape = shape;
    _radarShape = radar;
    
    _thrusting = kGreedyThrustNone;
    _feeding = kGreedyIdle;
    
    [self createSprites];
    
    [self createSpriteObjects];
    
    //Move greedy into layer Greedy so its shape doesn't impact eyeball or background asteroids
    shape->layers = LAYER_GREEDY;
    
    //Body
    _sprite = [cpCCSprite spriteWithShape:shape spriteFrameName:@"greedy_open_1.png"];
    [_batch addChild:_sprite];
    
    //_sprites
    [self addChild:_batch];
    [self goIdle:_sprite];
    
    //add crazy eye container
    //[self addChild:[[[GreedyEye alloc] init] autorelease]];
    
    [self startRadar];
    
    return self;
} 

- (void) step:(ccTime) delta
{
    if (_radar != nil)
    {
        CGPoint pos = [_sprite position];
        [_radar setPosition:pos];
        [_radar setRotation: CC_RADIANS_TO_DEGREES( - _radarShape->body->a)];
    }
    
    if (_flames != nil)
    {
        [_flames setRotation:[_sprite rotation]];
        cpFloat angle = _sprite.shape->body->a;
        cpVect offset = cpvrotate(cpvforangle(angle), ccp(0, -40));
        [_flames setPosition:cpvadd([_sprite position], offset)];
    }
}

-(void) updateThrustingAnimation
{
    
}

- (void) setThrusting:(int)value
{
    if (value == kGreedyThrustNone)
    {
        NSLog(@"update thrusting: nil");
        
        [loaderGreedySprite runAnimationWithUniqueName:@"flameon" onBody:_shape->body];
        
    }
    
    if (value >= kGreedyThrustLittle)
    {
        NSLog(@"update thrusting: zomg flames!");    
        

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


- (void) startRadar
{
    // radar
    if(_radar == nil)
    {
        _radar = [CCSprite spriteWithFile:@"radio_sweep.png"];    
        [_radar setPosition:[_sprite position]];  
        [_radar setRotation: _radarShape->body->a];
        
        [self addChild:_radar];
    }
}

- (BOOL) handleCollisionRadar:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
    NSLog(@"Radar detected asteroid");
    
    return YES;
}

- (void) stopRadar
{
    if(_radar != nil)
    {
        [self stopAllActions]; //remove the radar updater
        
        [self removeChild:_radar cleanup:YES];
        
        _radar = nil;  
    }
}

-(void) openUp
{
    [_sprite stopAllActions];
    [_sprite runAction:[CCSequence actions:_actionOpenUp, 
                        [CCCallFuncN actionWithTarget:self selector:@selector(wobbleHead:)],
                        nil]];
}

-(void) closeDown
{ 
    [_sprite stopAllActions];
    [_sprite runAction:[CCSequence actions:_actionCloseDown,
                        [CCCallFuncN actionWithTarget:self selector:@selector(goIdle:)],
                        nil]];
}

-(void) wobbleHead:(id)sender
{
    [_sprite stopAllActions];
	[sender runAction:_actionWobble];
}

-(void) goIdle:(id)sender
{
    _feeding = kGreedyIdle;
    [sender stopAllActions];
	[sender setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"greedy_close_body.png"]];
}

-(void) explode
{
    //Explosion *exp = 
    [[[Explosion alloc] initWithPosition:[_sprite position] inLayer:[[GameObjectCache sharedGameObjectCache] gameLayer]] autorelease];
    //[self addChild:exp];
    //[exp release];
}


-(void) dealloc
{
    NSLog(@"Dealloc GreedyView");
    [_actionCloseDown release];
    [_actionOpenUp release];
    [_actionWobble release];
    [self removeAllChildrenWithCleanup:YES];
	[super dealloc];
}

@end