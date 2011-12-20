//
//  PhysicsCache.m
//  greedy
//
//  Created by Richard Owen on 20/10/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "GameObjectCache.h"

@implementation GameObjectCache

static GameObjectCache *sharedGameObjectCache_=nil;

+ (GameObjectCache *) sharedGameObjectCache
{
//  static dispatch_once_t pred;
//  dispatch_once(&pred, ^{
//    sharedGameObjectCache_ = [[GameObjectCache alloc] init];
//  });
    
    if(!sharedGameObjectCache_)
        sharedGameObjectCache_ = [[GameObjectCache alloc] init];
    
  return sharedGameObjectCache_;
}

+(void)purgeGameObjectCache
{
    CCLOG(@"Purging Game Object Cache");
    [sharedGameObjectCache_ release];
	sharedGameObjectCache_ = nil;
}

+(id)alloc
{
	NSAssert(sharedGameObjectCache_ == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

//Add objects

-(void) addGameScene:(GameScene*)newGameScene
{
    CCLOG(@"GameObjectCache addGameScene");
   // NSAssert(gameScene_ == nil, @"gameScene member has already been set in GameObjectCache object ");
    
    if(gameScene_ != nil)
        [gameScene_ release];
    
    gameScene_ = newGameScene;  
    [gameScene_ retain];
}

-(void) addGameLayer:(GameLayer*)newGameLayer
{
    CCLOG(@"GameObjectCache addGameLayer");
   // NSAssert(gameLayer_ == nil, @"gameLayer member has already been set in GameObjectCache object ");
    
    if(gameLayer_ != nil)
        [gameLayer_ release];
    
    gameLayer_ = newGameLayer;  
    [gameLayer_ retain];
}

-(void) addBackground:(Background*)newBackground
{
    CCLOG(@"GameObjectCache addBackGround");
    // NSAssert(background_ == nil, @"Background member has already been set in GameObjectCache object ");
    
    if(background_ != nil)
        [background_ release];
    
    background_ = newBackground;  
    [background_ retain];
}

-(void) addGreedyView:(GreedyView*)newGreedyView
{
    CCLOG(@"GameObjectCache addGreedyView");
    // NSAssert(greedyView_ == nil, @"Background member has already been set in GameObjectCache object ");
    
    if(greedyView_ != nil)
        [greedyView_ release];
    
    greedyView_ = newGreedyView;  
    [greedyView_ retain];
}

-(void) addLifeMeter:(LifeMeter*)newLifeMeter
{
    CCLOG(@"GameObjectCache addLifeMeter");
    // NSAssert(lifemeter_ == nil, @"Background member has already been set in GameObjectCache object ");
    
    if(lifemeter_ != nil)
        [lifemeter_ release];
    
    lifemeter_ = newLifeMeter;  
    [lifemeter_ retain];
}

-(void) addSpaceManager:(SpaceManagerCocos2d *)newSpaceManager
{
   // NSAssert(spaceManager_ == nil, @"spaceManager member has already been set in GameObjectCache object ");
    CCLOG(@"GameObjectCache addSpaceManager");
    
    if(spaceManager_ != nil)
        [spaceManager_ release];
    
    spaceManager_ = newSpaceManager;
    [spaceManager_ retain];
}


//***********************
//Retrieve objects 

-(GameScene*) gameScene
{
    NSAssert(gameScene_ != nil, @"gameScene member has not been set in GameObjectCache object ");
    
    return gameScene_;
}

-(GameLayer*) gameLayer
{
    NSAssert(gameLayer_ != nil, @"gameLayer member has not been set in GameObjectCache object ");
    
    return gameLayer_;
}

-(Background*) background
{
    NSAssert(background_ != nil, @"background member has not been set in GameObjectCache object ");
    
    return background_;
}

-(GreedyView*) greedyView
{
    NSAssert(greedyView_ != nil, @"greedyView member has not been set in GameObjectCache object ");
    
    return greedyView_;
}

-(LifeMeter*) lifeMeter
{
    NSAssert(lifemeter_ != nil, @"lifeMeter member has not been set in GameObjectCache object ");
    
    return lifemeter_;
}


-(SpaceManagerCocos2d *) spaceManager
{
    NSAssert(spaceManager_ != nil, @"spaceManager member has not been set in GameObjectCache object ");
    
    return spaceManager_;
}

-(cpSpace*) space
{
    NSAssert(spaceManager_ != nil, @"spaceManager member has not been set in GameObjectCache object ");
    
    return spaceManager_.space;
}

- (id)init
{
    CCLOG(@"GameObjectCache Init");
	if( (self=[super init]) ) {
        spaceManager_ = nil;
        gameScene_ = nil;
        gameLayer_ = nil;
        background_ = nil;
        lifemeter_ = nil;
	}
	
	return self;
}

- (void)dealloc {
    CCLOG(@"GameObjectCache Dealloc");
    [lifemeter_ release];
    [background_ release];
    [gameLayer_ release];
    [gameScene_ release];
    [spaceManager_ release];
    
    [super dealloc];
}

@end
