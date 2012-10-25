//
//  Player.h
//  MonsterForm
//
//  Created by shahid.latif on 10/22/12.
//
//

#import <Foundation/Foundation.h>

@interface Player : NSObject {

    
}

@property int numberOfLives;
@property int userPoints;
@property CGPoint userPosition;

-(id) initWithLives:(int) lives;
-(id) init;

@end
