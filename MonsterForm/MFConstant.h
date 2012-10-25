//
//  MFConstant.h
//  MonsterForm
//
//  Created by shahid.latif on 10/22/12.
//
//

#import <Foundation/Foundation.h>

@interface MFConstant : NSObject

FOUNDATION_EXPORT NSString *const uidKey;
FOUNDATION_EXPORT NSString *const BASE_URL;
FOUNDATION_EXPORT NSString *const levelKey;
FOUNDATION_EXPORT NSString *const gameStateKey;

extern const int WIN_GAME_CRATERIA;

typedef enum {
    PLOW_TILE=1,
    GRASS_TILE
} TileMapGID;



@end
