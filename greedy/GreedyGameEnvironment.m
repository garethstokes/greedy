//
//  GreedyGameEnvironment.m
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "GreedyGameEnvironment.h"
#import "cocos2d.h"
#import "chipmunk.h"
#import "SpaceManagerCocos2d.h"

@implementation GreedyGameEnvironment

@synthesize manager=_spaceManager;

- (id) init
{
    if( (self=[super init])) {
        //allocate our space manager
        _spaceManager = [[SpaceManagerCocos2d alloc] init];
        
        //add four walls to our screen
        [_spaceManager addWindowContainmentWithFriction:1.0 elasticity:1.0 inset:cpvzero];
    }
    return self;
}

-(void) step:(ccTime)dt
{
    [_spaceManager step:dt];
}

@end
