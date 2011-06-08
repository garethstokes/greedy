//
//  Asteroid.h
//  greedy
//
//  Created by gareth stokes on 8/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"
#import "GameEnvironment.h"
#import "ConvexHull.h"

@interface Asteroid : CCLayer {
  ConvexHull *_convexHull;
  int _mass;
}

- (id) initWithEnvironment:(GameEnvironment *)environment withPosition:(cpVect)position;
- (cpFloat) area; 
- (int) mass;

@end
