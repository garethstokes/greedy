//
//  GreedyGameEnvironment.m
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "GameEnvironment.h"
#import "cocos2d.h"
#import "chipmunk.h"
#import "SpaceManagerCocos2d.h"

@implementation GameEnvironment

@synthesize manager=_spaceManager;

- (id) init
{
    if( (self=[super init])) {
      //allocate our space manager
      _spaceManager = [[SpaceManagerCocos2d alloc] init];
        
      //add four walls to our screen
      [_spaceManager addWindowContainmentWithFriction:0.0 elasticity:0.01f inset:cpvzero];
      [_spaceManager setGravity:ccp(0,0)];
    }
    return self;
}

-(void) step:(ccTime)dt
{
    [_spaceManager step:dt];
}

@end
