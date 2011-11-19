//
//  Explosion.m
//  greedy
//
//  Created by Richard Owen on 20/10/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "Explosion.h"
#import "SpriteHelperLoader.h"
#include "GameObjectCache.h"

typedef struct PartData{
    char*   name;
    int     percentageChanceOfEmmiting;
}PartData;

PartData normalParts[] = {
    {"bolt-hd",    25},
    {"cog-hd",     25},
    {"eye-hd",     25},
    {"key-hd",     25},
    {"nail-hd",    25},
    {"nut-hd",     25},
    {"shell_a-hd", 25},
    {"shell_b-hd", 25},
    {"shell_c-hd", 25},
    {"shell_d-hd", 25},
    {"spring-hd",  25},
    {"stem-hd",    25},
    {"tooth-hd",   25},
    {"wheel-hd",    25}      
};

PartData sexyParts[] = {
    {"bra-hd",          10},
    {"foamfinger-hd",   10},
    {"hammer-hd",       10},
    {"heels-hd",        10},
    {"rubber_ducky-hd", 10},
    {"thong-hd",        10}    
};

@implementation Explosion

- (void)addRingOfFire:(SpriteHelperLoader *)loader position:(CGPoint)position inLayer:(CCLayer *)inLayer  {
    animSpr = [loader spriteWithUniqueName:@"ring1" atPosition:ccp(0,0) inLayer:nil];
    
    animAction = [loader runAnimationWithUniqueName:@"ringoffire" onSprite:animSpr]; 
    
    [self addChild:animSpr];
    
    [self setScale:FLAME_SCALE_START];
    
    CCSequence *seq = [CCSequence actions:
                       [CCScaleBy actionWithDuration:EXPLOSION_START_TIME scale:FLAME_SCALE_EXPLODE / FLAME_SCALE_START],
                       [CCSpawn actions:
                        [CCScaleBy actionWithDuration:EXPLOSION_FADE_TIME scale:FLAME_SCALE_FADE / FLAME_SCALE_EXPLODE], 
                        [CCFadeOut actionWithDuration:EXPLOSION_FADE_TIME], 
                        nil
                        ],
                       nil
                       ];
    
    [self runAction:seq];
    
    [inLayer addChild:self];
    
}

-(id) initWithPosition:(CGPoint)position inLayer:(CCLayer *)inLayer
{
    self = [super init];
    
    if(self != nil){
        
        [self setPosition:position];
        
        //load in the animation
        SpriteHelperLoader *loader = [[SpriteHelperLoader alloc] initWithContentOfFile:@"explosion"];
        
        [self addRingOfFire: loader position: position inLayer: inLayer];
        
        int length = sizeof(normalParts) / sizeof(PartData);
        for( int i = 0; i < length ; i++)
        {
            PartData part = normalParts[i];
            if ((arc4random() %100 + 1) <= part.percentageChanceOfEmmiting)
            {
                [loader bodyWithUniqueName:[NSString stringWithUTF8String: part.name] atPosition:position inLayer:inLayer world: [[GameObjectCache sharedGameObjectCache] space]];
            }
        }
        
        [[[GameObjectCache sharedGameObjectCache] spaceManager] applyLinearExplosionAt:position radius:20 maxForce:50 layers:LAYER_RADAR group:CP_NO_GROUP];
        
        [loader release];
    }
    
    return self;
}

- (void) setOpacity:(GLubyte)opacity
{
    [super setOpacity:opacity];
    
    CCNode *c;
	CCARRAY_FOREACH(children_, c)
	{
        if([c conformsToProtocol:@protocol(CCRGBAProtocol)])
        {
            id<CCRGBAProtocol> rgbaC = (id<CCRGBAProtocol>)c;
            [rgbaC setOpacity:opacity];
        }
    }
}

/*
 
 CGPoint explosionPosition = [_sprite position];
 CGPoint test = [self convertToWorldSpace:explosionPosition];
 CCLOG(@"test x:%f | y:%f",test.x, test.y);
 
 //remove greedy
 [_sprite stopAllActions];
 [self removeChild:_sprite cleanup:NO];
 [self removeChild:_batch cleanup:NO];
 [self removeChild:_radar cleanup:NO];
 [self removeCrazyEyeAndContainer];
 
 //add random bits
 CCSpriteFrameCache * cache = [CCSpriteFrameCache sharedSpriteFrameCache];
 
 //load in the masters files ... ie the PNG and zwoptex plist
 _batchExplosion = [CCSpriteBatchNode batchNodeWithFile:@"parts.png" capacity:14]; 
 [cache addSpriteFramesWithFile:@"parts.plist"];
 
 // choose some parts
 for (NSString * objName in [NSArray arrayWithObjects: 
 @"bolt.png", 
 @"cog.png", 
 @"eye.png", 
 @"key.png", 
 @"nail.png", 
 @"nut.png", 
 @"shell_a.png", 
 @"shell_b.png", 
 @"shell_c.png", 
 @"shell_d.png", 
 @"spring.png", 
 @"stem.png", 
 @"tooth.png", 
 @"wheel.png", 
 nil]) {
 if (CCRANDOM_0_1() > 0.5) {
 CCSpriteFrame* frame1 = [cache spriteFrameByName:objName];
 CGPoint randPos = explosionPosition;
 randPos.x += CCRANDOM_0_1() - CCRANDOM_0_1();
 randPos.y += CCRANDOM_0_1()- CCRANDOM_0_1();
 
 cpShape* aShape = [_manager addRectAt:randPos mass:1.0 width:frame1.rectInPixels.size.width height:frame1.rectInPixels.size.height rotation:0.0 ];
 aShape->layers = LAYER_RADAR;
 _spriteExplosion1 = [cpCCSprite spriteWithShape:aShape spriteFrameName:objName];
 [_batchExplosion addChild:_spriteExplosion1];
 }
 
 //ring of death
 //load in the masters files ... ie the PNG and zwoptex plist
 _batchRingOfDeath = [CCSpriteBatchNode batchNodeWithFile:@"ring_of_death.png" capacity:3]; 
 [cache addSpriteFramesWithFile:@"ring_of_death.plist"]; 
 
 //Ring of death
 NSMutableArray *explosionFrames = [NSMutableArray array];
 [explosionFrames addObject:[cache spriteFrameByName:@"ring_of_death_1.png"]];
 [explosionFrames addObject:[cache spriteFrameByName:@"ring_of_death_2.png"]];
 [explosionFrames addObject:[cache spriteFrameByName:@"ring_of_death_3.png"]];
 
 spriteRingOfDeath = [CCSprite spriteWithSpriteFrameName:@"ring_of_death_1.png"];
 [_batchRingOfDeath addChild:spriteRingOfDeath];
 
 spriteRingOfDeath = [CCSprite spriteWithSpriteFrameName:@"ring_of_death_2.png"];
 [_batchRingOfDeath addChild:spriteRingOfDeath];
 
 spriteRingOfDeath = [CCSprite spriteWithSpriteFrameName:@"ring_of_death_3.png"];
 [_batchRingOfDeath addChild:spriteRingOfDeath];
 
 #define EXPLOSION_START_TIME 1.0f   // speed of explosion in seconds
 #define EXPLOSION_FADE_TIME  2.0f   // duration of fade out and second scale
 #define FLAME_FPS = 30.0f
 #define FLAME_SPEED ((30.0f / 3.0f) * 1.0f / 60.0f)
 #define FLAME_COUNT ((30.0f / 3.0f) * 1.0f / 60.0f) / 3.0
 #define FLAME_SCALE_START 0.1f      // start at 10%
 #define FLAME_SCALE_EXPLODE 2.0f    // explode out to 200%
 #define FLAME_SCALE_FADE 4.0f       // fade out to 400%
 
 CCAnimation *animation = [CCAnimation animationWithFrames:explosionFrames delay:FLAME_SPEED];
 CCAnimate *action = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation] times:EXPLOSION_START_TIME / FLAME_COUNT];
 CCSpawn *spawner1 = [CCSpawn actions:[CCScaleBy actionWithDuration:EXPLOSION_START_TIME scale:FLAME_SCALE_EXPLODE / FLAME_SCALE_START], action, nil];
 
 CCAnimate *action2 = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation] times:EXPLOSION_FADE_TIME / FLAME_COUNT];
 CCSpawn *spawner2 = [CCSpawn actions:[CCScaleBy actionWithDuration:EXPLOSION_FADE_TIME scale:FLAME_SCALE_FADE / FLAME_SCALE_EXPLODE], [CCFadeOut actionWithDuration:EXPLOSION_FADE_TIME], action2,nil];
 
 
 [spriteRingOfDeath setScale:FLAME_SCALE_START];
 [spriteRingOfDeath setPosition:explosionPosition];
 
 [spriteRingOfDeath stopAllActions];
 [spriteRingOfDeath runAction:[CCSequence actions:
 spawner1,
 spawner2,
 nil]];
 
 
 }
 
 //load in the masters files ... ie the PNG and zwoptex plist
 _batchExplosionSexy = [CCSpriteBatchNode batchNodeWithFile:@"random_elements.png" capacity:6]; 
 [cache addSpriteFramesWithFile:@"random_elements.plist"];
 
 // choose some parts
 for (NSString * objNameSexy in [NSArray arrayWithObjects: 
 @"bra.png", 
 @"foamfinger.png", 
 @"hammer.png", 
 @"heels.png", 
 @"rubber_ducky.png", 
 @"thong.png", 
 nil]) {
 if (CCRANDOM_0_1() < 0.16) {
 CCSpriteFrame* frame1 = [cache spriteFrameByName:objNameSexy];
 CGPoint randPos = explosionPosition;
 randPos.x += CCRANDOM_0_1() - CCRANDOM_0_1();
 randPos.y += CCRANDOM_0_1() - CCRANDOM_0_1();
 
 cpShape* aShape = [_manager addRectAt:randPos mass:1.0 width:frame1.rectInPixels.size.width height:frame1.rectInPixels.size.height rotation:0.0 ];
 aShape->layers = LAYER_RADAR;
 _spriteExplosion1 = [cpCCSprite spriteWithShape:aShape spriteFrameName:objNameSexy];
 [_batchExplosionSexy addChild:_spriteExplosion1];
 }
 }
 
 [self addChild:_batchExplosion];
 [self addChild:_batchExplosionSexy];
 [self addChild: _batchRingOfDeath];
 
 [_manager applyLinearExplosionAt:explosionPosition radius:20 maxForce:50 layers:LAYER_RADAR group:CP_NO_GROUP];
 
 */

@end
