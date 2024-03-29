//
//  Background.m
//  greedy
//
//  Created by gareth stokes on 8/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "Background.h"
#import "cocos2d.h"
#import "BackgroundAsteroids.h"

@implementation Background

- (id) initWithLayers:(NSArray *)layers
{
    // star layer background
    CCLOG(@"  self ref count alloc 1: %d", [self retainCount]);
    
    if(!(self = [super init])) return nil;
    
    CCLOG(@"  self ref count alloc 2: %d", [self retainCount]);
    
    //[self addChild:sprite];
    // create a void node, a parent node
    _parallax = [CCParallaxNode node];
    
    NSString *l1 = [layers valueForKey:@"layer1"];
    NSString *l2 = [layers valueForKey:@"layer2"];
    
    CCSprite *stars = [CCSprite spriteWithFile:l1];
    CCSprite *nebula = [CCSprite spriteWithFile:l2];
    BackgroundAsteroids *background = [[[BackgroundAsteroids alloc] init] autorelease];
    
    CCLOG(@"  self ref count alloc 3: %d", [self retainCount]);
    
    // background image is moved at a ratio of 0.4x, 0.5y
    [_parallax addChild:stars z:-1 parallaxRatio:ccp(0.0f,0.05f) positionOffset:ccp(160, 314)];
    [_parallax addChild:nebula z:2 parallaxRatio:ccp(0.0f,0.15f) positionOffset:ccp(160, 450)];
    [_parallax addChild:background z:3 parallaxRatio:ccp(0.0f,0.1f) positionOffset:ccp(0, 0)];
    
    [self addChild:_parallax z:0];
    
    CCLOG(@"  self ref count alloc 4: %d", [self retainCount]);
    
    return self;
}

- (void) setPosition:(CGPoint)position
{
    [_parallax setPosition:position];
    [super setPosition:position];
}

-(void) dealloc
{
    NSLog(@"Dealloc Background");
    [super dealloc];
}

@end
