//
//  GameState.m
//  MonsterForm
//
//  Created by shahid.latif on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "JSONKit.h"
#import "MFConstant.h"

@interface GameState ()

-(NSArray*) positionStringFromArray:(NSArray*) array;

@end

@implementation GameState

@synthesize flowerPosition;
@synthesize monsterLocations = _monsterLocations;
@synthesize userScore;
@synthesize userPosition;
@synthesize uid = _uid;
@synthesize badgePosition;
@synthesize isTreasureBagFound;
@synthesize isMonsterFound;
@synthesize grassLocations = _grassLocations;

-(void) dealloc {

    [self.monsterLocations release];
    [super dealloc];
}

-(CGPoint) getPositionFromString:(NSString *) str {

    CGPoint locationFromString = CGPointMake(0, 0);
    NSString *value = [str stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
    NSArray *flowerPositionArray = [value componentsSeparatedByString:@","];
    
    if ([flowerPositionArray count] > 0) {
        
        locationFromString.x = [[flowerPositionArray objectAtIndex:0] intValue];
        locationFromString.y =  [[flowerPositionArray objectAtIndex:1] intValue];
    }
    
    return locationFromString;
}


-(NSString*) convertPositionToString:(CGPoint) position {

    NSMutableString *finalString = [[NSMutableString alloc] init];
    
    [finalString appendString:@"{"];
    [finalString appendFormat:@"%d,",((int)position.x)];
    [finalString appendFormat:@"%d",((int)position.y)];
    [finalString appendString:@"}"];
    
    return finalString;

}

-(void) updateUserScore:(int) score {
    
    userScore += score;
}

-(NSArray*) positionStringFromArray:(NSArray*) array {

    NSMutableArray *resultantArray = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSValue *value in array) {
        CGPoint position = [value CGPointValue];
        [resultantArray addObject:[self convertPositionToString:position]];
    }
    
    return resultantArray;
}

-(id) initWithGameState:(NSData*) data {

    self = [super init];
    
    if (self) {

        NSDictionary *gameState = [data objectFromJSONData];
        
        NSLog(@"Game State:%@",gameState);
        
        _monsterLocations = [[NSMutableArray alloc] init];
        
        _grassLocations  = [[NSMutableDictionary alloc] init];
        
        NSString *flowerPositionStr = [gameState objectForKey:@"flowerPosition"];
        
        flowerPosition = [self getPositionFromString:flowerPositionStr];
        
        NSString *playerPositionStr = [gameState objectForKey:@"playerPosition"];
        
        userPosition = [self getPositionFromString:playerPositionStr];
        
        id monsterPos = [gameState objectForKey:@"monsterPosition"];
        
        if ([monsterPos isKindOfClass:[NSArray class]]) {
            
            for (NSString *mPos in monsterPos) {
                
                CGPoint position = [self getPositionFromString:mPos];
                [self.monsterLocations addObject:[NSValue valueWithCGPoint:position]];
            }
        }
        
        self.uid = [gameState objectForKey:@"uid"];
        
        if (!self.uid) {
            self.uid = [[NSUserDefaults standardUserDefaults] objectForKey:uidKey];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:self.uid forKey:uidKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        userScore = [[gameState objectForKey:@"score"] intValue];

        NSString *badgePositionStr = [gameState objectForKey:@"bagPosition"];

        badgePosition = [self getPositionFromString:badgePositionStr];
        isTreasureBagFound = [[gameState objectForKey:@"isTreasureBagFound"] boolValue];
        isMonsterFound = [[gameState objectForKey:@"isMonsterFound"] boolValue];
    }
    return self;
}

-(NSString*) toJSONString {

    NSMutableDictionary *finalJSON = [[NSMutableDictionary alloc] init];
    
    [finalJSON setObject:[self convertPositionToString:userPosition] forKey:@"playerPosition"];
    [finalJSON setObject:[NSNumber numberWithInt:userScore] forKey:@"score"];
    [finalJSON setObject:[NSString stringWithFormat:@"%d",isTreasureBagFound] forKey:@"isTreasureBagFound"];
    [finalJSON setObject:[NSString stringWithFormat:@"%d", isMonsterFound] forKey:@"isMonsterFound"];
    [finalJSON setObject:[self convertPositionToString:badgePosition] forKey:@"bagPosition"];
    
    [finalJSON setObject:[self positionStringFromArray:self.monsterLocations] forKey:@"monsterPosition"];
    
    NSMutableArray *_grassLocation = [[NSMutableArray alloc] init];
    
    for (NSString *key in self.grassLocations.allKeys) {
        NSValue *posValue = [self.grassLocations objectForKey:key];
        [_grassLocation addObject:[self convertPositionToString:[posValue CGPointValue]]];
    }
    [finalJSON setObject:_grassLocation forKey:@"grassPositions"];
    [_grassLocation release];
    
    NSLog(@"Final JSOn:%@",  [finalJSON JSONString]);
    return [finalJSON JSONString];
}

@end
