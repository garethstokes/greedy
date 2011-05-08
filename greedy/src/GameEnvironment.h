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
#import "SpaceManagerCocos2d.h"

@interface GameEnvironment : CCNode {
    SpaceManagerCocos2d *_spaceManager;
}

@property (nonatomic, retain) SpaceManagerCocos2d *manager;
-(void) step:(ccTime)dt;
-(void) addNewAsteroidSprite:(cpBody *)body;
@end