//
//  GreedyView.h
//  greedy
//
//  Created by gareth stokes on 1/06/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "SpaceManager.h"
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
    Radar* spriteRadar;
    
    CCAction* animFlameStart;
    CCAction* animFlameOn;
    CCAction* animFlameStop;
    
    CPCCNODE_MEM_VARS;
}

- (id) initWithShape:(cpShape *)shape radar:(cpShape *)radar;
- (void) setThrusting:(int)value;
- (void) updateFeeding:(int) value;
- (BOOL) isThrusting;

-(void) animationEndedFlameStart:(CCSprite*)sprite;

//radar stuff
- (void) startRadar;
- (void) stopRadar;

//animation commands
-(void) goIdle:(id)sender;
-(void) openUp;
-(void) closeDown;
-(void) explode;



@end
