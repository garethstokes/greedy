//
//  GreedyGameEnvironment.h
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "chipmunk.h"

@interface GameEnvironment : CCNode {
}

-(void) addCircularWorldContainmentWithFriction:(cpFloat)friction elasticity:(cpFloat)elasticity radius:(cpFloat)radius;
-(void) addTopDownWorldContainmentWithFriction:(cpFloat)friction elasticity:(cpFloat)elasticity height:(cpFloat)height width:(cpFloat)width;
- (void) addOutOfBoundsForAsteroids:(cpFloat)friction elasticity:(cpFloat)elasticity height:(cpFloat)height width:(cpFloat)width;
@end