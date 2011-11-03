//
//  GreedyView.h
//  greedy
//
//  Created by gareth stokes on 1/06/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "SpaceManagerCocos2d.h"
#import "GameConfig.h"
#import "SpriteHelperLoader.h"
#import "Radar.h"

@interface GreedyView : CCNode<cpCCNodeProtocol> {
    cpShape *_shape;
    
    int _thrusting;
    int _feeding;
    CCAction *_thrustAction;
    
    NSMutableArray *_flameFrames;
    CCSpriteBatchNode *_batch;
        
    //animation
    CCAnimation *_animationOpenUp;
    CCAnimate *_actionOpenUp;
    CCActionInterval *_actionCloseDown;
    CCAnimate *_actionFlame;
    CCAnimate *_actionWobble;
    
    //spritehelper objects
    SpriteHelperLoader * loaderGreedySprite;
    CCSprite* spriteFlame;
    CCSprite* spriteGreedy;
    
    CCAction* animFlameStart;
    CCAction* animFlameOn;
    CCAction* animFlameStop;
    
    int _eatCount;
    
    CPCCNODE_MEM_VARS;
}

- (id) initWithShape:(cpShape *)shape;
- (void) setThrusting:(int)value;
- (BOOL) isThrusting;
-(void) incrementEating;
-(void) decrementEating;

-(void) animationEndedFlameStart:(CCSprite*)sprite;

//animation commands
-(void) goIdle:(id)sender;
-(void) openUp;
-(void) closeDown;
-(void) explode;



@end
