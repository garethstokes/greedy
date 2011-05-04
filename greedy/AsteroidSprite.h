//
//  AsteroidSprite.h
//  SpritePhysics
//
//  Created by Richard Owen on 6/04/11.
//  Copyright 2011 Digital Five. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// Importing Chipmunk headers
#import "chipmunk.h"

@interface AsteroidSprite : CCSprite {
    cpBody *body;
    cpShape *shape;
}

-(id) initWithSpace:(cpSpace *)worldSpace position:(CGPoint)position size:(int)size;

@end
