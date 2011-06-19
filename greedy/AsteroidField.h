//
//  AsteroidField.h
//  greedy
//
//  Created by Richard Owen on 13/06/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "SpaceManagerCocos2d.h"
#import "GameConfig.h"
#import "GameEnvironment.h"

@interface AsteroidField : CCNode {
  NSMutableArray *_asteroids;
}

@property (nonatomic, retain) NSMutableArray *asteroids;

- (id) initWithEnvironment:(GameEnvironment *)environment totalArea:(float)totalArea density:(float)density  Layer:(cpLayers)Layer;

@end
