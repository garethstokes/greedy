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
  
  CCLabelAtlas *_ScoreLabel;
}

- (id) initWithScore:(int)score level:(int)level;

@end
