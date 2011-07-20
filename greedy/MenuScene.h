//
//  MenuScene.h
//  greedy
//
//  Created by Gareth Stokes on 13/07/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "ChooseLevelLayer.h"

@interface MenuScene : CCScene{
  ChooseLevelLayer *_chooseLevel;
}

@property (nonatomic, retain) ChooseLevelLayer *chooseLevel;

+(id) scene;
@end
