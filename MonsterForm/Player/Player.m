//
//  Player.m
//  MonsterForm
//
//  Created by shahid.latif on 10/22/12.
//
//

#import "Player.h"

@implementation Player
@synthesize numberOfLives;
@synthesize userPosition;
@synthesize userPoints;

-(id) init {

    self = [super init];
    
    if (self) {
        numberOfLives = 3;
        userPoints = 0;
        userPosition = CGPointMake(0, 0);
    }
    
    return self;
}

-(id) initWithLives:(int) lives {

    self = [super init];
    
    if (self) {
        numberOfLives = lives;
    }
    
    return self;
    
}

@end
