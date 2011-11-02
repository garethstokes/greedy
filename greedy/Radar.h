//
//  Radar.h
//  greedy
//
//  Created by Richard Owen on 29/10/11.
//  Copyright 2011 Spacehip Studio. All rights reserved.
//

#import "cocos2d.h"

//@interface CCSprite(MySpriteRadar)
//-(void)setRotation:(float)rotation;
//@end

@interface Radar : CCSprite{
    float radarAngle;
}
-(id) initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect;
-(void)setRotation:(float)rot;

@end

/** Rotates a CCNode object clockwise a number of degrees by modiying it's rotation attribute.
 */
@interface CCRadarRotateBy : CCActionInterval <NSCopying>
{
	float angle_;
	float startAngle_;
}
/** creates the action */
+(id) actionWithDuration:(ccTime)duration angle:(float)deltaAngle;
/** initializes the action */
-(id) initWithDuration:(ccTime)duration angle:(float)deltaAngle;
@end
