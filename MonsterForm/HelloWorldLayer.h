//
//  HelloWorldLayer.h
//  MonsterForm
//
//  Created by shahid.latif on 10/18/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "HudLayer.h"
#import "GenericAnimation.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CCTMXTiledMap *map;
    
    CGPoint testPos;
    
    CCSprite *userPlayer;
    
    HudLayer *hudLayer;
    
    GenericAnimation *animation;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
