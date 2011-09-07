//
//  MainMenuLayer.h
//  greedy
//
//  Created by Richard Owen on 28/08/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"

@interface MainMenuLayer : CCLayer {
  CCMenu *_menuMain;
}

@property (nonatomic, retain) CCMenu *menuMain;

- (void)menuOptionTapped:(id)sender;
- (void)menuPlayTapped:(id)sender;

@end
