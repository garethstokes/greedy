//
//  GreedyGameEnvironment.h
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"
#import "SpaceManager.h"

@interface GreedyGameEnvironment : CCNode {
    SpaceManager *_spaceManager;
}

@end