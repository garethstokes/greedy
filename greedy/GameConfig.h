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
#define GREEDYTHRUST  200000.0f
#define PUPILGRAVITY  -100.0f

//Collision Codes
#define LAYER_GREEDY       0x0001
#define LAYER_GREEDY_EYE   0x0002
#define LAYER_BACKGROUND   0x0004
#define LAYER_DEFAULT      (CP_ALL_LAYERS && ~LAYER_GREEDY_EYE && ~LAYER_BACKGROUND)

#endif // __GAME_CONFIG_H