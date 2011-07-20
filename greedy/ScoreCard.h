//
//  ScoreCard.h
//  greedy
//
//  Created by Richard Owen on 6/07/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"


@interface ScoreCard : CCLayer {
@private
  int _score;
  int _level;
  ccTime _timeleft;
  
  CCLabelAtlas *_ScoreLabel;
  CCLabelAtlas *_TimeLabel;
}

- (id) initWithScore:(int)score level:(int)level time:(ccTime)time;

@end