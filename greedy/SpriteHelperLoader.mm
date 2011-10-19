//  This file was generated with SpriteHelper
//  http://www.spritehelper.org
//
//  SpriteHelperLoader.mm
//  Created by Bogdan Vladu
//  Copyright 2011 Bogdan Vladu. All rights reserved.
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

#import "SpriteHelperLoader.h"

/// converts degrees to radians
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0f * (float)M_PI)
/// converts radians to degrees
#define RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) / (float)M_PI * 180.0f)

#if TARGET_OS_EMBEDDED || TARGET_OS_IPHONE || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64

#define LHRectFromString(str) CGRectFromString(str)
#define LHPointFromString(str) CGPointFromString(str)
#else
#define LHRectFromString(str) NSRectToCGRect(NSRectFromString(str))
#define LHPointFromString(str) NSPointToCGPoint(NSPointFromString(str))
#endif

////////////////////////////////////////////////////////////////////////////////
@interface SpriteHelperLoader (Private)

-(CCSprite*) spriteFromDictionary:(NSDictionary*)spriteProp;

-(void) setSpriteProperties:(CCSprite*)ccsprite
           spriteProperties:(NSDictionary*)spriteProp
                   position:(CGPoint)point;

-(void) setShapePropertiesFromDictionary:(NSDictionary*)spritePhysic 
                                   shape:(cpShape*)shapeDef;

-(NSArray*) cpBodyFromDictionary:(NSDictionary*)spritePhysic
                       spriteProperties:(NSDictionary*)spriteProp
                                   data:(CCSprite*)ccsprite 
                                  world:(cpSpace*)space;

-(void)loadSpriteHelperSceneFile:(NSString*)levelFile 
                     inDirectory:(NSString*)subfolder
                    imgSubfolder:(NSString*)imgFolder;
@end

@implementation SpriteHelperLoader
////////////////////////////////////////////////////////////////////////////////
-(id) initWithContentOfFile:(NSString*)sceneFile
{
	NSAssert(nil!=sceneFile, @"Invalid file given to SpriteHelperLoader");
	
	if(!(self = [super init]))
	{
		NSLog(@"SpriteHelperLoader ****ERROR**** : [super init] failer ***");
		return self;
	}
	
	[self loadSpriteHelperSceneFile:sceneFile inDirectory:@"" imgSubfolder:@""];
	
	
	return self;
}
////////////////////////////////////////////////////////////////////////////////
-(id) initWithContentOfFile:(NSString*)sceneFile 
			 sceneSubfolder:(NSString*)sceneFolder
{
	NSAssert(nil!=sceneFile, @"Invalid file given to SceneHelperLoader");
	
	if(!(self = [super init]))
	{
		NSLog(@"SceneHelperLoader ****ERROR**** : [super init] failer ***");
		return self;
	}
	
	[self loadSpriteHelperSceneFile:sceneFile 
                       inDirectory:sceneFolder 
                      imgSubfolder:@""];
	
	return self;
	
}
////////////////////////////////////////////////////////////////////////////////
-(CCSprite*) spriteWithUniqueName:(NSString*)name 
                       atPosition:(CGPoint)point 
                          inLayer:(CCLayer*)layer
{
    NSDictionary* spriteProperties = [shSprites objectForKey:name];
    
    if(nil != spriteProperties)
    {
        NSDictionary* texProp = [spriteProperties objectForKey:@"TextureProperties"];
        CCSprite* spr = [self spriteFromDictionary:texProp];
        
        [self setSpriteProperties:spr spriteProperties:texProp position:point];
        
        if(nil != layer)
            [layer addChild:spr z:[[texProp objectForKey:@"ZOrder"] intValue]];
        
        return spr;
    }
    
    return nil;
}
////////////////////////////////////////////////////////////////////////////////
-(NSArray*) bodyWithUniqueName:(NSString*)name 
                   atPosition:(CGPoint)point 
                      inLayer:(CCLayer*)layer 
                        world:(cpSpace*)world
{
    NSDictionary* spriteProperties = [shSprites objectForKey:name];
    
    if(nil != spriteProperties)
    {
        NSDictionary* texProp = [spriteProperties objectForKey:@"TextureProperties"];
        CCSprite* spr = [self spriteFromDictionary:texProp];
        [self setSpriteProperties:spr spriteProperties:texProp position:point];
        
        NSDictionary* phyProp = [spriteProperties objectForKey:@"PhysicProperties"];
        
        
        NSArray* shapes = [self cpBodyFromDictionary:phyProp
                                 spriteProperties:texProp
                                             data:spr
                                            world:world];
        if(nil != layer)
            [layer addChild:spr z:[[texProp objectForKey:@"ZOrder"] intValue]];
        
        return shapes;
    }
    
	return nil;
}
////////////////////////////////////////////////////////////////////////////////
-(CCSprite*) spriteInBatchWithUniqueName:(NSString*)name 
                              atPosition:(CGPoint)point 
                                 inLayer:(CCLayer*)layer
{
    NSDictionary* spriteProperties = [shSprites objectForKey:name];
    
    if(nil != spriteProperties)
    {
        NSDictionary* texProp = [spriteProperties objectForKey:@"TextureProperties"];
        CCSprite* spr = [self spriteFromDictionary:texProp];
        
        [self setSpriteProperties:spr spriteProperties:texProp position:point];
        
        CCSpriteBatchNode* node = [batchInfo objectForKey:[texProp objectForKey:@"Image"]];
        if(nil == node)
        {
            node = [CCSpriteBatchNode batchNodeWithFile:[texProp objectForKey:@"Image"]];
            if(nil != layer)
                [layer addChild:node z:batchOrder];
            
            [batchInfo setObject:node forKey:[texProp objectForKey:@"Image"]];
        }
        
        if(nil != node)
            [node addChild:spr z:[[texProp objectForKey:@"ZOrder"] intValue]];
        
        return spr;
    }
    
    return nil;
}
////////////////////////////////////////////////////////////////////////////////
-(NSArray*) bodyInBatchWithUniqueName:(NSString*)name 
                           atPosition:(CGPoint)point 
                              inLayer:(CCLayer*)layer 
                                world:(cpSpace*)world
{
    NSDictionary* spriteProperties = [shSprites objectForKey:name];
    
    if(nil != spriteProperties)
    {
        NSDictionary* texProp = [spriteProperties objectForKey:@"TextureProperties"];
        CCSprite* spr = [self spriteFromDictionary:texProp];
        [self setSpriteProperties:spr spriteProperties:texProp position:point];
        
        NSDictionary* phyProp = [spriteProperties objectForKey:@"PhysicProperties"];
        
        
        NSArray* shapes = [self cpBodyFromDictionary:phyProp
                                    spriteProperties:texProp
                                                data:spr
                                               world:world];
        
        CCSpriteBatchNode* node = [batchInfo objectForKey:[texProp objectForKey:@"Image"]];
        if(nil == node)
        {
            node = [CCSpriteBatchNode batchNodeWithFile:[texProp objectForKey:@"Image"]];
            if(nil != layer)
                [layer addChild:node z:batchOrder];
            
            [batchInfo setObject:node forKey:[texProp objectForKey:@"Image"]];
        }
        
        if(nil != node)
            [node addChild:spr z:[[texProp objectForKey:@"ZOrder"] intValue]];
        
        return shapes;
    }
    
	return nil;
}
////////////////////////////////////////////////////////////////////////////////
-(CCAction*) runAnimationWithUniqueName:(NSString*)animName
                               onSprite:(CCSprite*)sprite
                     endNotificationSEL:(SEL)notifSEL
                     endNotificationObj:(id)notifObj
{
    if([sprite usesBatchNode])
    {
        NSLog(@"SpriteHelper WARNING: Can't create animation on sprites that uses batch nodes. Please use spriteWithUniqueName or bodyWithUniqueName to create the sprite");
        return 0;
    }          

    NSDictionary* animInfo = [shAnimations objectForKey:animName];
    
    if(nil == animInfo)
        return nil;
    
    NSArray* framesNames = [animInfo objectForKey:@"Frames"];
    
    bool loop = [[animInfo objectForKey:@"Loop"] boolValue];
    int repetitions = [[animInfo objectForKey:@"Repetitions"] intValue];
    float speed = [[animInfo objectForKey:@"Speed"] floatValue];
    bool startAtLaunch = [[animInfo objectForKey:@"StartAtLaunch"] boolValue];
    
    if([framesNames count] == 0)
        return nil;
    
    NSString* frame1Name = [framesNames objectAtIndex:0];
    NSDictionary* spriteProperties = [shSprites objectForKey:frame1Name];
    
    if(nil != spriteProperties)
    {
        NSDictionary* texProp = [spriteProperties objectForKey:@"TextureProperties"];
        
        CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:[texProp objectForKey:@"Image"]];
        [sprite setTexture:tex];

        CCSpriteFrame* frame1 = [CCSpriteFrame frameWithTexture:[sprite texture] 
                                                           rect:LHRectFromString([texProp objectForKey:@"Frame"])];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame1 
                                                               name:frame1Name];
        
        
        NSMutableArray *frames = [NSMutableArray array];
        
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                           frame1Name]];
        
        
        for(unsigned int i = 1; i < [framesNames count]; ++i)
        {
            NSString* frameName = [framesNames objectAtIndex:i];
            NSDictionary* frameSprite = [shSprites objectForKey:frameName];
            NSDictionary* rectTexProp = [frameSprite objectForKey:@"TextureProperties"];
            
            CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:[sprite texture] 
                                                              rect:LHRectFromString([rectTexProp objectForKey:@"Frame"])];
            
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame 
                                                                   name:frameName];
            
            
            [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                               frameName]];            
        }
        
        CCAnimation *anim = [CCAnimation animationWithFrames:frames delay:speed];
        
        CCAction* animAct; 
        
        if(loop == false)
        {            
            if(nil != notifSEL && nil != notifObj)
            {
                id notifAct = [CCCallFuncND actionWithTarget:notifObj 
                                                    selector:notifSEL
                                                        data:sprite];
                
                animAct = [CCSequence actionOne:[CCAnimate actionWithAnimation:anim 
                                                          restoreOriginalFrame:NO] two:notifAct];
            }
            else
            {
                animAct = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:anim 
                                                               restoreOriginalFrame:NO] 
                                               times:repetitions];       
            }
        }
        else
            animAct = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:anim 
                                 restoreOriginalFrame:NO]];
        
        if(startAtLaunch)
            [sprite runAction:animAct];
        
        return animAct;
    }
    
    return nil;
}
////////////////////////////////////////////////////////////////////////////////
-(CCAction*) runAnimationWithUniqueName:(NSString*)animName
                               onSprite:(CCSprite*)sprite
{
    return [self runAnimationWithUniqueName:animName
                                   onSprite:sprite 
                         endNotificationSEL:nil
                         endNotificationObj:nil];
}

////////////////////////////////////////////////////////////////////////////////
-(CCAction*) runAnimationWithUniqueName:(NSString *)animName 
                                 onBody:(NSArray *)shapesArray;
{
    return [self runAnimationWithUniqueName:animName
                                     onBody:shapesArray
                         endNotificationSEL:nil
                         endNotificationObj:nil];
}
////////////////////////////////////////////////////////////////////////////////
-(CCAction*) runAnimationWithUniqueName:(NSString *)animName 
                                 onBody:(NSArray *)shapesArray
                     endNotificationSEL:(SEL)notifSEL
                     endNotificationObj:(id)notifObj
{
    if(shapesArray == 0)
        return nil;
    
    if([shapesArray count] == 0)
        return nil;
    
    NSValue* val = [shapesArray objectAtIndex:0];
    if(val == nil)
        return nil;
    
    cpShape* shape = (cpShape*)[val pointerValue];
    
    CCSprite* sprite = (CCSprite*)shape->body->data;
    
    return [self runAnimationWithUniqueName:animName onSprite:sprite];    
}

////////////////////////////////////////////////////////////////////////////////
+(bool) removeChipmunkBody:(NSArray*)shapes 
                 fromSpace:(cpSpace*)space
               spriteLayer:(CCLayer*)layer
{	
	if(nil != shapes && 0 != space)
	{
        cpBody* body = 0;
        for(NSValue* value in shapes)
        {
            
            cpShape* shape = (cpShape*)[value pointerValue];
            body = shape->body;
            
            cpSpaceRemoveShape(space, shape);
            cpShapeFree(shape);
        }
        
        CCSprite* ccsprite = (CCSprite*)body->data;
        
        if([ccsprite usesBatchNode])
        {
            CCSpriteBatchNode* node = [ccsprite batchNode];
            [node removeChild:ccsprite cleanup:YES];
        }
        else
        {
            [layer removeChild:ccsprite cleanup:YES];
        }
		
        cpSpaceRemoveBody(space, body);
        cpBodyFree(body);
        
        return true;
	}
	
	return false;
}
////////////////////////////////////////////////////////////////////////////////
+(CCSprite*) spriteForBody:(NSArray*)shapes
{
    if(nil != shapes){
        for(NSValue* value in shapes){
            cpShape* shape = (cpShape*)[value pointerValue];
            return (CCSprite*)shape->data;
        }
    }
    return nil;
}
////////////////////////////////////////////////////////////////////////////////
-(oneway void) release
{
	[shSprites release];
    [shAnimations release];
    [batchInfo release];
}
///////////////////////////PRIVATE METHODS//////////////////////////////////////
-(CCSprite*) spriteFromDictionary:(NSDictionary*)spriteProp
{
	return [CCSprite spriteWithFile:[spriteProp objectForKey:@"Image"] 
                               rect:LHRectFromString([spriteProp objectForKey:@"Frame"])];
}
////////////////////////////////////////////////////////////////////////////////
-(void) setSpriteProperties:(CCSprite*)ccsprite
           spriteProperties:(NSDictionary*)spriteProp
                   position:(CGPoint)point
{
	[ccsprite setPosition:point];
	[ccsprite setOpacity:255*[[spriteProp objectForKey:@"Opacity"] floatValue]];
	CGRect color = LHRectFromString([spriteProp objectForKey:@"Color"]);
	[ccsprite setColor:ccc3(255*color.origin.x, 255*color.origin.y, 255*color.size.width)];
	CGPoint scale = LHPointFromString([spriteProp objectForKey:@"Scale"]);
	[ccsprite setScaleX:scale.x];
	[ccsprite setScaleY:scale.y];
}
////////////////////////////////////////////////////////////////////////////////
-(void) setShapePropertiesFromDictionary:(NSDictionary*)spritePhysic 
                                   shape:(cpShape*)shapeDef
{
	//shapeDef->density = [[spritePhysic objectForKey:@"Density"] floatValue];
	shapeDef->u = [[spritePhysic objectForKey:@"Friction"] floatValue];
	shapeDef->e = [[spritePhysic objectForKey:@"Restitution"] floatValue];
	shapeDef->sensor = [[spritePhysic objectForKey:@"IsSenzor"] boolValue];
	
    //	shapeDef->filter.categoryBits = [[spritePhysic objectForKey:@"Category"] intValue];
	shapeDef->layers = [[spritePhysic objectForKey:@"Mask"] intValue];
	shapeDef->group = [[spritePhysic objectForKey:@"Group"] intValue];	
}
////////////////////////////////////////////////////////////////////////////////
//returns NSMutableArray with NSValue with cpShape pointers
-(NSArray*) cpBodyFromDictionary:(NSDictionary*)spritePhysic
                       spriteProperties:(NSDictionary*)spriteProp
                                   data:(CCSprite*)ccsprite 
                                  world:(cpSpace*)space
{
	cpBody *body;
	
    float mass = [[spritePhysic objectForKey:@"Density"] floatValue];
    
	CGPoint position = ccp([ccsprite position].x, [ccsprite position].y);//
	
    // NSLog(@"Position %f %f", position.x, position.y);
	//0 static
	//1 kinematic
	//2 dynamic
	//3 no physic - should not get here
	int bodyType = [[spritePhysic objectForKey:@"PhysicType"] intValue];
	if(bodyType == 3) //in case the user wants to create a body with a sprite that has type as "NO_PHYSIC"
		bodyType = 2;
	
    NSMutableArray* arrayOfShapes = [[NSMutableArray alloc] init];
    
	NSArray* fixtures = [spritePhysic objectForKey:@"Fixtures"];
	CGPoint scale = LHPointFromString([spriteProp objectForKey:@"Scale"]); 
    CGRect frame = LHRectFromString([spriteProp objectForKey:@"Frame"]);
    CGSize size = frame.size;
    

    //not available for Chipmunk
//    body->SetFixedRotation([[spritePhysic objectForKey:@"IsFixedRot"] boolValue]);
//    body->SetBullet([[spritePhysic objectForKey:@"IsBullet"] boolValue]);
//    body->SetSleepingAllowed([[spritePhysic objectForKey:@"CanSleep"] boolValue]);
    
    //shape position Offset
    int shapeOffsetX = [[spritePhysic objectForKey:@"ShapePositionOffsetX"] intValue];
    int shapeOffsetY = [[spritePhysic objectForKey:@"ShapePositionOffsetY"] intValue];
    
    float linearVelocityX = [[spritePhysic objectForKey:@"LinearVelocityX"] floatValue];
    float linearVelocityY = [[spritePhysic objectForKey:@"LinearVelocityX"] floatValue];
    
//    float linearDamping = [[spritePhysic objectForKey:@"LinearDamping"] floatValue]; 
    float angularVelocity = [[spritePhysic objectForKey:@"AngularVelocity"] floatValue];
//    float angularDamping = [[spritePhysic objectForKey:@"AngularDamping"] floatValue];     
    
    
    //not available for Chipmunk
//    body->SetLinearDamping(linearDamping);
//    body->SetAngularDamping(angularDamping);

    
    
	if(fixtures == nil || [fixtures count] == 0 || [[fixtures objectAtIndex:0] count] == 0)
	{
		cpShape *shape;
        
        int shapeBorderX = [[spritePhysic objectForKey:@"ShapeBorderW"] intValue];
        int shapeBorderY = [[spritePhysic objectForKey:@"ShapeBorderH"] intValue];

		if([[spritePhysic objectForKey:@"IsCircle"] boolValue])
		{
			float innerDiameter = 0;
			float outterDiameter =(size.width*scale.x - shapeBorderX/2)/2;
            
            if(bodyType == 0)
            {
                body = cpBodyNewStatic();
            }
            else{
                body = cpBodyNew(mass, cpMomentForCircle(mass, innerDiameter, outterDiameter, cpvzero));
                cpSpaceAddBody(space, body);
            }
            body->p = position;
            cpBodySetAngle(body, DEGREES_TO_RADIANS(-1*[[spriteProp objectForKey:@"Angle"] floatValue]));
            body->data = ccsprite;

            
			float radius = (size.width*scale.x - shapeBorderX/2)/2;
			shape = cpCircleShapeNew(body, radius, ccp(shapeOffsetX/2, -shapeOffsetY/2));
		}
		else
		{	
            float width = size.width*scale.x - shapeBorderX/2;
			float height = size.height*scale.y - shapeBorderY/2;
            
            int vsize = 4;
			CGPoint *verts = new CGPoint[vsize];
			
            verts[3].x = ( (-1* size.width + shapeBorderX/2.0f)*scale.x/2.0f +shapeOffsetX/2);
            verts[3].y = ( (-1* size.height + shapeBorderY/2.0f)*scale.y/2.0f-shapeOffsetY/2);
            
            verts[2].x = ( (+ size.width - shapeBorderX/2.0f)*scale.x/2.0f+shapeOffsetX/2);
            verts[2].y = ( (-1* size.height + shapeBorderY/2.0f)*scale.y/2.0f-shapeOffsetY/2);
            
            verts[1].x = ( (+ size.width - shapeBorderX/2.0f)*scale.x/2.0f+shapeOffsetX/2);
            verts[1].y = ( (+ size.height - shapeBorderY/2.0f)*scale.y/2.0f-shapeOffsetY/2);
            
            verts[0].x = ( (-1* size.width + shapeBorderX/2.0f)*scale.x/2.0f+shapeOffsetX/2);
            verts[0].y = ( (+ size.height - shapeBorderY/2.0f)*scale.y/2.0f-shapeOffsetY/2);
            
            if(bodyType == 0)
            {
                body = cpBodyNewStatic();
            }
            else{
                
                body = cpBodyNew(mass, cpMomentForBox(mass, width, height));
                cpSpaceAddBody(space, body);
            }
            body->p = position;
            cpBodySetAngle(body, DEGREES_TO_RADIANS(-1*[[spriteProp objectForKey:@"Angle"] floatValue]));
            body->data = ccsprite;

            shape = cpPolyShapeNew(body, vsize, verts, CGPointZero);
            delete verts;
		}
		[self setShapePropertiesFromDictionary:spritePhysic shape:shape];
		shape->data = ccsprite;
        
        [arrayOfShapes addObject:[NSValue valueWithPointer:shape]];
        cpSpaceAddShape(space, shape);
    }
	else
	{
        float width = size.width*scale.x;
        float height = size.height*scale.y;
        
        if(bodyType == 0){
            body = cpBodyNewStatic();
        }
        else{
            body = cpBodyNew(mass, cpMomentForBox(mass, width, height));
            cpSpaceAddBody(space, body);
        }
        body->p = position;
        body->data = ccsprite;
        cpBodySetAngle(body, DEGREES_TO_RADIANS(-1*[[spriteProp objectForKey:@"Angle"] floatValue]));

		for(NSArray* curFixture in fixtures)
		{
			int size = (int)[curFixture count];
			CGPoint *verts = new CGPoint[size];
			int i = 0;
            for(int p = [curFixture count] -1; p > -1 ; --p)
			{
                NSString* pointStr = [curFixture objectAtIndex:p];
				CGPoint point = LHPointFromString(pointStr);
                verts[i] = ccp(point.x*(scale.x)+shapeOffsetX/2, 
                               point.y*(scale.y)-shapeOffsetY/2);
				++i;
			}
            
            cpShape* shape = cpPolyShapeNew(body, size, verts, CGPointZero);
            [self setShapePropertiesFromDictionary:spritePhysic shape:shape];
            
            shape->data = ccsprite;
            
            [arrayOfShapes addObject:[NSValue valueWithPointer:shape]];
            cpSpaceAddShape(space, shape);
            delete verts;
            
		}
	}
    
    body->v = ccp(linearVelocityX, linearVelocityY);
    body->w = angularVelocity;

    
	return arrayOfShapes;
	
}
////////////////////////////////////////////////////////////////////////////////
-(void)loadSpriteHelperSceneFile:(NSString*)sceneFile 
                     inDirectory:(NSString*)subfolder
                    imgSubfolder:(NSString *)imgFolder
{
	NSString *path = [[NSBundle mainBundle] pathForResource:sceneFile 
                                                     ofType:@"pshs" 
                                                inDirectory:subfolder]; 
	
	NSAssert(nil!=path, @"Invalid scene file. Please add the SpriteHelper scene file to Resource folder. Please do not add extension in the given string.");
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	
	bool fileInCorrectFormat =	![[dictionary objectForKey:@"Author"] isEqualToString:@"Bogdan Vladu"] || 
                                ![[dictionary objectForKey:@"CreatedWith"] isEqualToString:@"SpriteHelper"];
	
	NSAssert(true !=fileInCorrectFormat, @"This file was not created with SpriteHelper or file is damaged.");
		
    batchOrder = 0;
    batchInfo = [[NSMutableDictionary alloc] init];
    if(nil != [dictionary objectForKey:@"BatchZOrder"])
        batchOrder = [[dictionary objectForKey:@"BatchZOrder"] intValue];

	////////////////////////LOAD SPRITES////////////////////////////////////////
    shSprites = [[NSMutableDictionary alloc] init];
    
    NSArray* tempArray = [dictionary objectForKey:@"SPRITES_INFO"];
    //we do this in order to be easier to find a sprite info when we want to 
    //create a body or a CCSprite
    for(NSDictionary* curSprite in tempArray)
    {
        NSDictionary* sprProp = [curSprite objectForKey:@"TextureProperties"];
        if(nil != sprProp)
        {
            [shSprites setObject:curSprite 
                          forKey:[sprProp objectForKey:@"Name"]];
        }
    }
    
    shAnimations = [[NSMutableDictionary alloc] init];
    NSArray* tempAnim = [dictionary objectForKey:@"ANIMATION_INFO"];
    for(NSDictionary* curAnim in tempAnim)
    {
        NSString* name = [curAnim objectForKey:@"UniqueName"];
        
        if(nil != name)
        {
            [shAnimations setObject:curAnim 
                             forKey:name];
        }
    }
}
////////////////////////////////////////////////////////////////////////////////
@end
