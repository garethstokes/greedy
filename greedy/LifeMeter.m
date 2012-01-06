//
//  LifeMeter.m
//  greedy
//
//  Created by Richard Owen on 29/05/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "LifeMeter.h"


@implementation LifeMeter

- (id) initLifeMeter:(SpriteHelperLoader *) loader
{
    CCLOG(@"LifeMeter: initLifeMeter");
    
    if(!(self = [super init])) return nil;
    
    //Load crashGlow
    _spriteGlow = [loader spriteWithUniqueName:@"hud_life_hit" atPosition:ccp(0,0) inLayer:nil];
    [_spriteGlow setOpacity:0.0];
    [self addChild:_spriteGlow z:-1];
    
    // load the sprite sheet
    _lifeMeterBatchNode = [[[CCSpriteBatchNode alloc] initWithFile:@"oranges.png" capacity:11] autorelease];
    
    //grab the cache singleton
    CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    
    //Create a holder for the frames
    CCSpriteFrame *frame;
    
    // create the frames
    frame = [[[CCSpriteFrame alloc] initWithTexture:_lifeMeterBatchNode.textureAtlas.texture rect:CGRectMake(0, 0, 0, 0)] autorelease];
    [cache addSpriteFrame:frame name:@"lifeBar0"];  
    
    for(int i = 1; i <= 10; i++)
    {
        frame = [[[CCSpriteFrame alloc] initWithTexture:_lifeMeterBatchNode.textureAtlas.texture rect:CGRectMake(0, 0, 8 + (i *9), 8)] autorelease];
        [cache addSpriteFrame:frame name:[NSString stringWithFormat:@"lifeBar%d", i]];
    };
    
    //Set to full bars
    _lifeBars = [CCSprite spriteWithSpriteFrame:[cache spriteFrameByName:@"lifeBar10"]];
    _lifeBars.position = ccp(0, 0);
    [_lifeBars setAnchorPoint:ccp(0,0)];
    [_lifeMeterBatchNode addChild:_lifeBars];
    
    // add the sprite batch
    [self addChild:_lifeMeterBatchNode];
    
    //Return the object
    return self;
}

- (void) hit
{
    [_spriteGlow runAction:[CCSequence actions:[CCFadeTo actionWithDuration:0.2 opacity:255.0], [CCFadeTo actionWithDuration:0.5 opacity:0.0], nil]];
}

- (void) setLifeLevel:(int) level
{  
    //sanity check
    if(level < 0) level = 0;
    if(level > 10) level = 10;
    
    [_lifeBars setDisplayFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"lifeBar%d", level]]];
    
    _lifeBars.position = ccp(-44, -3);
}

-(void) dealloc
{
    NSLog(@"Dealloc LifeMeter");
    [self removeAllChildrenWithCleanup:YES];
	[super dealloc];
}

@end
