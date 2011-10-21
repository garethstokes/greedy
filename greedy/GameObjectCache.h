//
//  PhysicsCache.h
//  greedy
//
//  Created by Richard Owen on 20/10/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "SpaceManagerCocos2d.h"
#import "GameScene.h"
#import "GameLayer.h"
#import "Background.h"
#import "LifeMeter.h"

@interface GameObjectCache : NSObject
{
    GameScene * gameScene_;
    GameLayer * gameLayer_;
    SpaceManagerCocos2d *spaceManager_;
    Background * background_;
    LifeMeter *lifemeter_;
    GreedyView *greedyView_;
}

/** Retruns ths shared instance of the Game Object cache */
+ (GameObjectCache *) sharedGameObjectCache;

/** Purges the cache. It releases the scene, Layer and Physics stuffs.
 */
+(void)purgeGameObjectCache;

-(void) addSpaceManager:(SpaceManagerCocos2d *)newSpaceManager;
-(void) addGameScene:(GameScene*)newGameScene;
-(void) addGameLayer:(GameLayer*)newGameLayer;
-(void) addBackground:(Background*)newBackground;
-(void) addLifeMeter:(LifeMeter*)newLifeMeter;
-(void) addGreedyView:(GreedyView*)newGreedyView;

-(SpaceManagerCocos2d *) spaceManager;
-(cpSpace*) space;

-(GameScene*) gameScene;
-(GameLayer*) gameLayer;
-(Background*) background;
-(LifeMeter*) lifeMeter;
-(GreedyView*) greedyView;

@end
