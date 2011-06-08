//
//  BackgroundAsteroids.h
//  greedy
//
//  Created by gareth stokes on 8/06/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "GameEnvironment.h"

@interface BackgroundAsteroids : CCNode {
  GameEnvironment *_environment;
  NSMutableArray *_asteroids;
}

@end