//
//  World.m
//  greedy
//
//  Created by Gareth Stokes on 20/07/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "World.h"

@implementation World

@synthesize name = _name;
@synthesize levels = _levels;

- (id)init
{
    self = [super init];
    if (self) {
      // Initialization code here.
      _levels = [NSMutableArray arrayWithCapacity:12];
    }
    
    return self;
}

@end
