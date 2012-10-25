//
//  GameState.h
//  MonsterForm
//
//  Created by shahid.latif on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MFRequest.h"
@interface GameState : NSObject {
    
    MFRequest *request;
}

-(id) initWithGameState:(NSData*) data;

@property CGPoint flowerPosition;
@property CGPoint badgePosition;
@property CGPoint userPosition;
@property int userScore;
@property BOOL isTreasureBagFound;
@property BOOL isMonsterFound;
@property (nonatomic, retain) NSString *uid;
@property(nonatomic, retain) NSMutableArray *monsterLocations;
@property(nonatomic, retain) NSMutableDictionary *grassLocations;

- (NSString*) convertPositionToString:(CGPoint) position;
- (CGPoint) getPositionFromString:(NSString *) str;

-(NSString*) toJSONString;

-(void) updateUserScore:(int) score;

@end
