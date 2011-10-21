//
//  GreedyGameScene.m
//  greedy
//
//  Created by gareth stokes on 4/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "GameScene.h"
#import "Background.h"
#import "Balsamic.h"
#import "ScoreCard.h"
#import "GameObjectCache.h"

@implementation GameScene

@synthesize environment;
@synthesize scene;

+(id) sceneWithLevel:(int)level
{
    CCLOG(@" GameScene: sceneWithLevel");
    
	// 'scene' is an autorelease object.
	GameScene *scene = [GameScene node];
    
    //Create the environment
    scene.environment = [[[GameEnvironment alloc] init] autorelease];
    
    //create the engine
    scene->_engine = [[GDKaosEngine alloc] initWorldSize:CGSizeMake(500.0, 1800.0) withDensity:10.0f];  
    
    // star layer background
    [[GameObjectCache sharedGameObjectCache] addBackground:[[[Background alloc] initWithEnvironment:scene.environment] autorelease]];
    [scene addChild:[[GameObjectCache sharedGameObjectCache] background] z:0];
    
    //Game Layer
    [[GameObjectCache sharedGameObjectCache] addGameLayer:[[[GameLayer alloc] initWithEnvironment:scene.environment level:level] autorelease]];
    [scene addChild:[[GameObjectCache sharedGameObjectCache] gameLayer] z:10];
    
    //HUD
    //scene.hudLayer = [[[HudLayer alloc] initWithGameLayer:[[GameObjectCache sharedGameObjectCache] gameLayer]] autorelease];
    [scene addChild:[[[HudLayer alloc] initWithGameLayer:[[GameObjectCache sharedGameObjectCache] gameLayer]] autorelease] z:50];
    
    scene->_scorecard = [[ScoreCard alloc] initWithScore:1000 level:1 time:12.34];
    //[scene addChild:scene->_scorecard  z:100];
    
    [[[GameObjectCache sharedGameObjectCache] gameLayer] startLevel];
    
    [[GameObjectCache sharedGameObjectCache] addGameScene: scene];
    
    
	// return the scene
    scene->_level = level;
	return scene;
}

- (void) showScore:(int) score time:(ccTime)time
{
    if(_scorecard != nil) return;
    
    //[self removeChild:self.hudLayer cleanup:YES];
    
    _scorecard = [[ScoreCard alloc] initWithScore:score level:1 time:time];
    [self addChild:_scorecard  z:100];
}

- (void) showDeath
{
    if(_deathcard != nil) return;
    
    //[self removeChild:self.hudLayer cleanup:YES];
    
    _deathcard = [[DeathCard alloc] init];
    [self addChild:_deathcard  z:100];
}

- (GameScene *) sceneFromCurrent
{
    return [GameScene sceneWithLevel:_level];
}

- (void) dealloc
{
    NSLog(@"Dealloc GameScene");
    
    //[[GameObjectCache sharedGameObjectCache] addBackground:nil];
    //[[GameObjectCache sharedGameObjectCache] addGameLayer:nil];
    //[[GameObjectCache sharedGameObjectCache] addGameScene:nil];
    
    [self removeAllChildrenWithCleanup:YES];
    
    [super dealloc];
    
}

@end
