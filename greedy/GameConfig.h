//
//  GameConfig.h
//  greedy
//
//  Created by Richard Owen on 4/05/11.
//  Copyright Digital Five 2011. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//
// Define here the type of autorotation that you want for your game
//
#define GAME_AUTOROTATION kGameAutorotationNone

// turns on debug messages and such
#define kDebugFalse 0
#define kDebugTrue 1
#define IS_DEBUG_MODE kDebugFalse


//greedy stuff
#define GREEDYMASS    2000.0f
#define GREEDYTHRUST  200000

//Collision Codes
#define LAYER_MAIN      1
#define LAYER_GREEDY    2
#define LAYER_ASTEROID  3


#endif // __GAME_CONFIG_H