//  This file was generated with SpriteHelper
//  http://www.spritehelper.org
//
//  SpriteHelperLoader.h
//  Created by Bogdan Vladu
//  Copyright 2011 Bogdan Vladu. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//  The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//  Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//  This notice may not be removed or altered from any source distribution.
//  By "software" the author refers to this code file and not the application 
//  that was used to generate this file.
//
////////////////////////////////////////////////////////////////////////////////
//
//  Version history
//  v1.1 First draft for SpriteHelper 1.7
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"

@interface SpriteHelperLoader : NSObject {
	
	NSMutableDictionary* shSprites;
    NSMutableDictionary* shAnimations;
    
    NSMutableDictionary* batchInfo; //contains CCBatchNode;
    int batchOrder;
}

////////////////////////////////////////////////////////////////////////////////

-(id) initWithContentOfFile:(NSString*)sceneFile;

////////////////////////////////////////////////////////////////////////////////

-(id) initWithContentOfFile:(NSString*)sceneFile 
			 sceneSubfolder:(NSString*)sceneFolder;

////////////////////////////////////////////////////////////////////////////////


-(CCSprite*) spriteWithUniqueName:(NSString*)name 
                       atPosition:(CGPoint)point 
                          inLayer:(CCLayer*)layer;

//will return array of cpShape*
/* //example of use
for(NSValue* val in returnedArray)
{
    cpShape* shape = (cpShape*)[val pointerValue];
    cpBody* shape->body;
    CCSprite* sprite = (CCSprite*)shape->data;
}
*/
-(NSArray*) bodyWithUniqueName:(NSString*)name 
                   atPosition:(CGPoint)point 
                      inLayer:(CCLayer*)layer 
                        world:(cpSpace*)world;

////////////////////////////////////////////////////////////////////////////////

-(CCSprite*) spriteInBatchWithUniqueName:(NSString*)name 
                              atPosition:(CGPoint)point 
                                 inLayer:(CCLayer*)layer;

//will return array of cpShape* 
/* //example of use
 for(NSValue* val in returnedArray)
 {
 cpShape* shape = (cpShape*)[val pointerValue];
 cpBody* shape->body;
 CCSprite* sprite = (CCSprite*)shape->data;
 }
 */
-(NSArray*) bodyInBatchWithUniqueName:(NSString*)name 
                          atPosition:(CGPoint)point 
                             inLayer:(CCLayer*)layer 
                               world:(cpSpace*)world;

////////////////////////////////////////////////////////////////////////////////

//the returned CCAction* should be used to stop the animation 
//e.g: [yourSprite stopAction:returnedAction];
//and if the animation does not have Start At Launch activated it should be used
//to start the animation e.g: [yourSprite runAction:returnedAction];
//
//Notifications
//Method should look like this -(void) animationEndedOnSprite:(CCSprite*)sprite
//registration should be like this:
/*
 animAction = [pLoader runAnimationWithUniqueName:@"PlayerJump" 
 onSprite:animSpr
 endNotificationSEL:@selector(animationEndedOnSprite:) 
 endNotificationObj:self]; 
 */

-(CCAction*) runAnimationWithUniqueName:(NSString*)animName
                               onSprite:(CCSprite*)sprite;

-(CCAction*) runAnimationWithUniqueName:(NSString*)animName
                               onSprite:(CCSprite*)sprite 
                     endNotificationSEL:(SEL)notifSEL
                     endNotificationObj:(id)notifObj;


//shapesArray is the same array returned by 
//bodyWithUniqueName or bodyInBatchWithUniqueName methods
-(CCAction*) runAnimationWithUniqueName:(NSString *)animName 
                                 onBody:(NSArray *)shapesArray;

-(CCAction*) runAnimationWithUniqueName:(NSString *)animName 
                                 onBody:(NSArray *)shapesArray
                     endNotificationSEL:(SEL)notifSEL
                     endNotificationObj:(id)notifObj;


////////////////////////////////////////////////////////////////////////////////
//HELPER METHODS

//remove a body created with SpriteHelper code
//"shapes" is the same array returned by bodyWithUniqueName or bodyInBatchWithUniqueName
+(bool) removeChipmunkBody:(NSArray*)shapes 
                 fromSpace:(cpSpace*)space
               spriteLayer:(CCLayer*)layer;

//"shapes" is the same array returned by bodyWithUniqueName or bodyInBatchWithUniqueName 
+(CCSprite*) spriteForBody:(NSArray*)shapes;
@end

