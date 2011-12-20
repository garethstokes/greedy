//
//  OreAnimation.h
//  greedy
//
//  Created by Richard Owen on 19/12/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCSprite.h"

//Crosshairs timings
#define CROSS_FADE_IN_TIME 0.5
#define CROSS_MAX_ROTATION 180
#define CROSS_ROTATION_TIME 1.5
#define CROSS_MOVE_TIME 2.0

// Score Label Animation
#define STARTTIME 0.75
#define STARTSCALE 1.25
#define ENDTIME 0.75
#define ENDSCALE 1.0
#define REMOVETIME 0.5
#define MOVEMENT_LENGTH 100

@interface OreAnimation : CCNode {
    CCLabelAtlas *_ScoreLabel;
    float _totalScore;
    NSTimeInterval lastTime;
}

-(id) initWithPosition:(CGPoint) position;
-(void) addPoint:(CGPoint) position;
-(void) addScore:(float) score;
-(void) endAnimation;

@end
