//
//  OptionsMenuLayer.h
//  greedy
//
//  Created by Richard Owen on 28/08/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCSlider.h"

@interface OptionsMenuLayer : CCLayer <CCSliderControlDelegate> {
  CCSlider *controlSlider;
  CCSlider *soundSlider;  
}

- (id) init:(bool)inGame;


@end
