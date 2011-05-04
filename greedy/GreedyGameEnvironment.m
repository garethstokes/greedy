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

@implementation GreedyGameEnvironment

@synthesize manager=_spaceManager;

- (id) init
{
    if( (self=[super init])) {
        _spaceManager = [[SpaceManager alloc] init];
    }
    return self;
}

-(void) step:(ccTime)dt
{
    [_spaceManager step:dt];
}

@end
