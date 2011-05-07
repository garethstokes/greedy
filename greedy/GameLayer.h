//
//  GreedyGameLayer.h
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 spacehip studio. All rights reserved.
//

#import "cocos2d.h"
#import "chipmunk.h"
#import "GameEnvironment.h"

@interface GameLayer : CCLayer
{
    GameEnvironment *_environment;
}

-(void) step:(ccTime)dt;
-(void) addNewAsteroidSprite: (float)x y:(float)y;

@end
