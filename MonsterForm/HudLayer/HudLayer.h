//
//  HudLayer.h
//  MonsterForm
//
//  Created by shahid.latif on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"

@interface HudLayer : CCLayer {
    
    
    CCLabelTTF * userLifeLabel;
    CCLabelTTF * pointLabel;

    Player *player;
    
}

-(void) addUserPoints:(const int) uPoints;

-(int) playerLife;
-(void) playerLostLife;

@end
