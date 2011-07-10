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
#import "GameConfig.h"

@interface Asteroid : CCNode {
  ConvexHull *_convexHull;
  int _mass;
  cpShape *_shape;
}

- (id) initWithEnvironment:(GameEnvironment *)environment withPosition:(cpVect)position withLayer:(cpLayers)withLayer;

- (id) initWithEnvironment:(GameEnvironment *)environment 
                 withLayer:(cpLayers)withLayer 
                  withSize:(float) size 
              withPosition:(cpVect) withPosition;

- (cpFloat) area; 
- (int) mass;

@end
