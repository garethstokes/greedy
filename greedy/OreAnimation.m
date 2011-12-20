//
//  OreAnimation.m
//  greedy
//
//  Created by Richard Owen on 19/12/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "OreAnimation.h"


@implementation OreAnimation

static ccColor3B spriteColors[] = {{255,255,255},{255,255,0},{166,166,166}};

-(void) addCrosshairAtPostion:(CGPoint) position
{
    CCSprite *spr = [CCSprite spriteWithFile:@"crosshairs-hd.png"];
    
    [spr setPosition:position];
    [spr setRotation:arc4random() % 360];
    [spr setColor:(spriteColors[arc4random() % 3])];
    //[spr setScale:100 / (((arc4random() % 4) + 1) * 25)];
    
    [spr runAction:[CCSpawn actions:
                    [CCFadeOut actionWithDuration:CROSS_FADE_IN_TIME], 
                    [CCRotateBy actionWithDuration:CROSS_ROTATION_TIME angle:(arc4random() % CROSS_MAX_ROTATION) * CCRANDOM_MINUS1_1()],
                    [CCMoveBy  actionWithDuration:CROSS_MOVE_TIME position:ccp((arc4random() % MOVEMENT_LENGTH) * CCRANDOM_MINUS1_1(), (arc4random() % MOVEMENT_LENGTH) * CCRANDOM_MINUS1_1())],
                    nil]
     ];
    
    [self addChild:spr z:5];
}

- (void) createScoreLabel {
    CCTexture2DPixelFormat currentFormat = [CCTexture2D defaultAlphaPixelFormat];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    _ScoreLabel = [[CCLabelAtlas labelWithString:@"" charMapFile:@"white_score.png" itemWidth:30 itemHeight:37 startCharMap:'.'] retain];
    [CCTexture2D setDefaultAlphaPixelFormat:currentFormat];
}

-(id) initWithPosition:(CGPoint) position
{
    self = [super init];
    if (self) {
        [self createScoreLabel];
        
        _totalScore = 0;
        [_ScoreLabel setPositionInPixels:position];
        
        //Add first animation at the start position
        [self addCrosshairAtPostion: position];
        lastTime = [NSDate timeIntervalSinceReferenceDate];
        
        [self setPositionInPixels:ccp(0,0)];
    }
    
    return self;
    
}

-(void) addPoint:(CGPoint) position
{    
    NSTimeInterval thisTime = [NSDate timeIntervalSinceReferenceDate];
    
    if((thisTime - lastTime) > 0.15){
        [self addCrosshairAtPostion: position];
        
        lastTime = thisTime;
    }
}

-(void) addScore:(float) score
{
    _totalScore += score;
    
    [_ScoreLabel setString:[NSString stringWithFormat:@"%0.0f", _totalScore]];
    
    //if new score start the animation
    if(_totalScore == score){
        
        [_ScoreLabel setScale:0.5];
        
        [_ScoreLabel runAction:[CCSequence actions:
                                [CCSpawn actions:
                                 [CCFadeIn actionWithDuration:STARTTIME], 
                                 [CCScaleBy actionWithDuration:STARTTIME scale:STARTSCALE],
                                 nil],
                                [CCScaleBy actionWithDuration:ENDTIME scale:ENDSCALE],
                                nil]
         ];
        
        [self addChild:_ScoreLabel z:10];
    }
}

-(void) endAnimation
{
    if(_ScoreLabel.opacity > 0.0){
        [_ScoreLabel stopAllActions];
        [_ScoreLabel runAction: [CCFadeOut actionWithDuration:REMOVETIME]];
    }
}

-(void) dealloc
{
    [self removeAllChildrenWithCleanup:YES];
    
    [super dealloc];
}

@end
