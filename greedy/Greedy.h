//
//  Greedy.h
//  greedy
//
//  Created by gareth stokes on 7/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"
#import "cocos2d.h"
#import "chipmunk.h"
#import "GameEnvironment.h"

enum {
	kGreedyOpen1 = 1,
 	kGreedyOpen2 = 2,
  kGreedyOpen3 = 3,
  kGreedyOpen4 = 4,
  kGreedyOpen5 = 5
};

@interface Greedy : CCLayer {
  cpShape *_shape;
  CCSprite *_sprite;
}

@property (nonatomic) cpShape *shape;

- (id) initWith:(GameEnvironment *)environment;
- (void) step:(ccTime) delta;

@end
