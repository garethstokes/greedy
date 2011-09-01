//
//  SettingsManager.h
//  greedy
//
//
//  Based on http://getsetgames.com/2009/10/07/saving-and-loading-user-data-and-preferences/
//

//How to use

/*
 
Set a value
===========
[[SettingsManager sharedSettingsManager] setValue:@"Greeting" newString:@"Hello"];
[[SettingsManager sharedSettingsManager] setValue:@"hiscore" newInt:10000];
 
Get a NSString value
====================
NSString* myValue = [[SettingsManager sharedSettingsManager] getValue:@"hiscore"];

Get an Int value
================
int myInt = [[SettingsManager sharedSettingsManager] getInt:@"challenges_won"];

*/

#import <Foundation/Foundation.h>


@interface SettingsManager : NSObject {
	NSMutableDictionary* settings;
}

-(void)setValue:(NSString*)value newString:(NSString *)aValue;
-(void)setValue:(NSString*)value newInt:(int)aValue;

-(NSString *)getString:(NSString*)value;
-(NSString *)getString:(NSString*)value withDefault:(NSString *)withDefault;
-(int)getInt:(NSString*)value;
-(int)getInt:(NSString*)value withDefault:(int)withDefault;

-(void)save;
-(void)load;

-(void)logSettings;

+(SettingsManager*)sharedSettingsManager;
@end
