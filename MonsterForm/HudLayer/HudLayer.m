//
//  HudLayer.m
//  MonsterForm
//
//  Created by shahid.latif on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HudLayer.h"


@implementation HudLayer

-(id) init {
    
    self = [super init];
    
    if (self) {
        
        player = [[Player alloc] init];
        CGSize winSize = CGSizeMake(480.0f, 320.0f);
        userLifeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"User Lives:%d",player.numberOfLives] fontName:@"Arial" fontSize:12.0f];
        [userLifeLabel setColor:ccBLUE];
        [userLifeLabel setPosition:ccp(winSize.width - 40 , winSize.height - 20)];
        
        
        pointLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Points: %d",player.userPoints] fontName:@"Arial" fontSize:12.0f];
        [pointLabel setColor:ccBLUE];
        [pointLabel setPosition:ccp(40, winSize.height - 20)];
        
        [self addChild:userLifeLabel];
        [self addChild:pointLabel];
        
    }
    
    return self;

}

-(void) addUserPoints:(const int) uPoints {

    player.userPoints += uPoints;
    
    [pointLabel setString:[NSString stringWithFormat:@"Points: %d",player.userPoints]];
}

-(void) playerLostLife {

    player.numberOfLives -= 1;
    
    if (player.numberOfLives < 0) {
        player.numberOfLives = 0;
    }
    
    [userLifeLabel setString:[NSString stringWithFormat:@"User Lives: %d",player.numberOfLives]];
}

-(int) playerLife {

    return player.numberOfLives;
}

@end
