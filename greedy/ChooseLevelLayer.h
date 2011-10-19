//
//  ChooseLevelLayer.h
//  greedy
//
//  Created by Gareth Stokes on 13/07/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"
#import "SpriteHelperLoader.h"
#import "SettingsManager.h"

@interface ChooseLevelLayer : CCLayerColor{
    SpriteHelperLoader * _loader;
}

+(id) scene;

@end
