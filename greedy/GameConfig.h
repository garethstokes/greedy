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

//Collision Layers
/* 
                | Asteroid | Greedy | Out of bounds | Radar | Radar line | Finish line | background | eyeball | iris |
 --------------------------------------------------------------------------------------------------------------------|
 Asteroid       |    1     |   -    |               |   3   |     4      |             |            |
 --------------------------+--------+---------------+-------+------------+-------------+-----------------------------| 
 Greedy         |    2     |   -    |       5       |       |            |      6      |            |
 --------------------------+--------+---------------+-------+------------+-------------+-----------------------------|
 Out Of Bounds  |          |   -    |       -       |       |            |             |            |
 --------------------------+--------+---------------+-------+------------+-------------+-----------------------------|
 radar          |    3     |        |               |   -   |            |             |            |
 --------------------------+--------+---------------+-------+------------+-------------+-----------------------------|
 radar line     |    4     |        |               |       |     -      |             |            |
 --------------------------+--------+---------------+-------+------------+-------------+-----------------------------|
 finish line    |          |   6    |               |       |            |     -       |            |
 --------------------------------------------------------------------------------------+-----------------------------|
 background     |          |        |               |       |            |             |     9      |
 --------------------------------------------------------------------------------------+-----------------------+-----|
 eyeball        |          |        |               |       |            |             |            |    -     |  8  |
 --------------------------------------------------------------------------------------+-----------------------+-----|
 iris           |          |        |               |       |            |             |            |    8     |  -  |
 --------------------------------------------------------------------------------------+-----------------------------|
 
*/

#define LAYER_ONE           0x0001
#define LAYER_TWO           0x0002
#define LAYER_THREE         0x0004
#define LAYER_FOUR          0x0008
#define LAYER_FIVE          0x0010
#define LAYER_SIX           0x0020
#define LAYER_SEVEN         0x0040
#define LAYER_EIGHT         0x0080

#define LAYER_ASTEROID      (LAYER_ONE | LAYER_TWO | LAYER_THREE | LAYER_FOUR)
#define LAYER_GREEDY        (LAYER_TWO | LAYER_FIVE)
#define LAYER_OOB           LAYER_FIVE
#define LAYER_RADAR         LAYER_THREE
#define LAYER_RADARLINE     LAYER_FOUR
#define LAYER_FINISHLINE    LAYER_SIX
#define LAYER_BACKGROUND    (LAYER_SEVEN)
#define LAYER_EYEBALL       (LAYER_EIGHT)

//Collision groups
#define kAsteroidCollisionType            1
#define kGreedyCollisionType              2
#define kAsteroidRadarCollisionType       3
#define kGreedyRadarCollisionType         4
#define kGreedyFinishLineCollisionType    5
#define kGreedyRadarlineCollisionType     6
#define kOutOfBoundsCollisionType         7

#endif // __GAME_CONFIG_H