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
#import "utlist.h"
#import "Asteroid.h"

//This fan object to create a DL of
typedef struct AsteroidElement{
    Asteroid *asteroid;
    struct AsteroidElement *prev; /* needed for a doubly-linked list only */
    struct AsteroidElement *next; /* needed for singly- or doubly-linked lists */
}AsteroidElement;

@interface AsteroidField : CCLayer {
    CCSprite *_asteroidSkin;
    AsteroidElement *asteroids_;
    CCSprite *_noise;
}

- (id) initWithEnvironment:(GameEnvironment *)environment totalArea:(float)totalArea density:(float)density  Layer:(cpLayers)Layer;

@end
