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
#import "cpCCSprite.h"
#import "GameObject.h"

@interface AsteroidSprite : cpCCSprite {

}

-(id) initWithPoints:(NSArray *)convexHull size:(int)size withShape:(cpShape *)shape isBackground:(BOOL)isBackground;

@end
