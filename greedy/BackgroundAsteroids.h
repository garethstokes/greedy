//
//  BackgroundAsteroids.h
//  greedy
//
//  Created by gareth stokes on 8/06/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "AsteroidField.h"

@interface BackgroundAsteroids : CCNode {
  AsteroidField *_asteroidField;
}

-(id) init;

@end