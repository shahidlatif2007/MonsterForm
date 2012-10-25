//
//  GameLayer.h
//  MonsterForm
//
//  Created by shahid.latif on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "JSONKit.h"
#import "Player.h"
#import "GenericAnimation.h"
#import "GameState.h"

@class HudLayer;
@class GenericAnimation;

@interface GameLayer : CCLayer {
    
    HudLayer *hudLayer;
    
    CCTMXTiledMap *map;
    
    CGPoint testPos;
    
    CCSprite *userPlayer;

    GenericAnimation *animation;
    GameState *gameState;
    
    MFRequest *request_;

}

+ (CCScene*) sceneWithGameState:(NSData*) gameState;
+ (id) nodeWithData:(NSData*) data;

- (id) initWithGameState:(NSData*) gameState;


@end
