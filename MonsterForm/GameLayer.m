//
//  GameLayer.m
//  MonsterForm
//
//  Created by shahid.latif on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"

#import "HudLayer.h"
#import "MFSprite.h"
#import "MFConstant.h"

@interface GameLayer()
-(void) moveMonster ;
-(void) showMonsterAtLocation:(CGPoint) location;
@end


@implementation GameLayer

+(CCScene*) sceneWithGameState:(NSData *)gameState {

    CCScene *scene = [CCScene node];
    
    
    GameLayer *gameLayer = [GameLayer nodeWithData:gameState];
    
    [scene addChild:gameLayer];
    
    return scene;
}

+(id) nodeWithData:(NSData*) data {

   return  [[[self alloc] initWithGameState:data] autorelease];
}

-(CGPoint) tilePositionFromLocation:(CGPoint) location {
    
    CGPoint pos = ccpSub(location, map.position);
    
    float halfMapWidth = map.mapSize.width * 0.5;
    
    float mapHeight = map.mapSize.height ;
    float tileWidth = map.tileSize.width / CC_CONTENT_SCALE_FACTOR();
    float tileHeight = map.tileSize.height / CC_CONTENT_SCALE_FACTOR();
    
    CGPoint tilePosDiv = ccp(pos.x/ tileWidth, pos.y/tileHeight);
    float inverseTileY = mapHeight - tilePosDiv.y;
    
    CGPoint finalPosition;
    
    finalPosition.x = (int) (inverseTileY + tilePosDiv.x - halfMapWidth);
    finalPosition.y = (int) ((inverseTileY - tilePosDiv.x + halfMapWidth));
    
    finalPosition.x = MAX(0, finalPosition.x);
    finalPosition.x = MIN(map.mapSize.width -1, finalPosition.x);
    
    finalPosition.y = MAX(0, finalPosition.y);
    finalPosition.y = MIN(map.mapSize.height - 1, finalPosition.y);
    
    
    
    return finalPosition;
}

-(CGPoint)locationFromTilePos:(CGPoint)tilePos
{
    
    float xValue = (map.tileSize.width * map.scaleX /2.0) / CC_CONTENT_SCALE_FACTOR()  * ( map.mapSize.width  + tilePos.x - tilePos.y - 1);
    float yValue = (map.tileSize.height * map.scaleY/2.0 ) / CC_CONTENT_SCALE_FACTOR() * (( map.mapSize.height * 2 - tilePos.x - tilePos.y) -1);
    
    CGPoint pixelPos = CGPointMake(xValue,
                                    yValue);
    
    
    pixelPos = ccpAdd(pixelPos, map.position);
    pixelPos.y += map.tileSize.height/4.0f;
    pixelPos.x += map.tileSize.width/4.0f;
    
    return pixelPos;
    
}


-(void) moveMonster {

    unsigned short int monsterCount = [[gameState monsterLocations] count];

    int randomeMonsterIndex = arc4random() % monsterCount;
    
    NSLog(@"Monster index to move:%d",randomeMonsterIndex);
    
    CGPoint mosnterLocation = [[[gameState monsterLocations] objectAtIndex:randomeMonsterIndex] CGPointValue];
    
    CGPoint userLocation = gameState.userPosition;
    
    BOOL isMonsterMoved = NO;
    
 
    if (mosnterLocation.x > userLocation.x) {
        mosnterLocation.x -=1;
        isMonsterMoved = YES;
    }else if(mosnterLocation.x < userLocation.x ) {
        isMonsterMoved = YES;
        mosnterLocation.x +=1;
    }
    
    
    if (mosnterLocation.y > userLocation.y) {
        isMonsterMoved = YES;
        mosnterLocation.y -=1;
    }else if(mosnterLocation.y < userLocation.y ) {
        isMonsterMoved = YES;
        mosnterLocation.y +=1;
    }
    
    [[gameState monsterLocations] removeObjectAtIndex:randomeMonsterIndex];
    
    [[gameState monsterLocations] addObject:[NSValue valueWithCGPoint:mosnterLocation]];
    
    [self showMonsterAtLocation:mosnterLocation];
}

-(void) showMonsterAtLocation:(CGPoint) location {
    
    CCSprite *animSprite = [animation animationSprite];
    
    [animSprite setPosition:[self locationFromTilePos:location]];
    [self addChild:animSprite];
    
    [animation runActionOnSprite:animSprite];

}

-(void) applicationGoesIntoBackground {

    NSString *userState = [gameState toJSONString];
    
    [[NSUserDefaults standardUserDefaults] setObject:userState forKey:gameStateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (!request_) {
        request_ = [[MFRequest alloc] initWithDelegate:nil];
        
    }
    [request_ saveGameState:userState uid:gameState.uid];
    
}

-(id) initWithGameState:(NSData*) gameSt {

    NSData *gmState = gameSt;
    if (self = [super init]) {

        gameState = [[GameState alloc] initWithGameState:gmState];

       //NSString *playerPosition = [data objectForKey:@"playerPosition"];
        
        hudLayer = [HudLayer node];
        
        [self addChild:hudLayer];
        
        
        CCSprite *background = [CCSprite spriteWithFile:@"bg.jpg"];
        
        [background setPosition:ccp(480/2.0f, 320/2.0f)];
		
		[self addChild:background];
        
        map = [CCTMXTiledMap tiledMapWithTMXFile:@"MonsterFormTileMap.tmx"];
        [self addChild:map];
        [map setPosition:ccp(4 ,24)];
        //[self debugMenu];
        
        self.isTouchEnabled = YES;
        NSLog(@"Map Position:%@",NSStringFromCGPoint(map.position));
        
        //How to Access All The TileMap Object
        
       // CCTMXLayer *layer = [map layerNamed:@"GroundLayer"];
        //CCTMXLayer *objectLayer = [map layerNamed:@"ObjectLayer"];
        
//        for (int x = 0; x <  map.mapSize.width; x++) {
//            for (int y = 0; y <  map.mapSize.height; y++) {
//                
//                unsigned int tileGID = [layer tileGIDAt:ccp(x, y)];
//                
//                if (tileGID!=0) {
//                    
//                    NSDictionary *properties = [map propertiesForGID:tileGID];
//                    
//                    if (1) {
//                        
//                        CGPoint pos = [self locationFromTilePos:ccp(x,y)];
//                        
//                        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@",NSStringFromCGPoint(ccp(x,y))] fontName:@"Arial" fontSize:10.0f];
//                        [label setPosition:pos];
//                        [self addChild:label];
//                        
//                    }
//                }
//                
//            }
//            
//        }
        

        
        userPlayer = [CCSprite spriteWithFile:@"player.png"];
        
        NSLog(@"Player Location:%@",NSStringFromCGPoint(gameState.userPosition));
        CGPoint playerPosition = [self locationFromTilePos:gameState.userPosition];
        
        [userPlayer setPosition:playerPosition];
        [self addChild:userPlayer];
        
        
        hudLayer = [HudLayer node];
        [self addChild:hudLayer];
        
        NSArray *monstersLocations = [gameState monsterLocations];
        
        
        
        animation = [[GenericAnimation alloc] initWithMonsterPlistFileNameOnLayer:self];
        
        
        for (NSValue *monsterPos in monstersLocations) {
            [self showMonsterAtLocation:[monsterPos CGPointValue]];
             
        }
        
        MFSprite *flowerSprite = [MFSprite spriteWithFile:@"flower.png"];
        [flowerSprite setPosition:[self locationFromTilePos:gameState.flowerPosition]];
        [self addChild:flowerSprite];
        [flowerSprite showAnimationOnSprite];
        
        MFSprite *badgeSprite = [MFSprite spriteWithFile:@"bag.PNG"];
        [badgeSprite setPosition:[self locationFromTilePos:gameState.badgePosition]];
        [self addChild:badgeSprite];
        [badgeSprite showAnimationOnSprite];
        
        [self schedule:@selector(moveMonster) interval:5.0f];
        
        self.isTouchEnabled = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationGoesIntoBackground) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;

}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    if (userPlayer.numberOfRunningActions != 0) {
        return;
    }
    
    CCTMXLayer *groundLayer = [map layerNamed:@"GroundLayer"];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchViewPoint = [touch locationInView:[touch view]];
    
    CGPoint convertedPoint = [[CCDirector sharedDirector] convertToGL:[self convertToNodeSpace:touchViewPoint]];
    
    CGPoint tileCoordPoint = [self tilePositionFromLocation:convertedPoint];
    
    
    
    //[groundLayer removeTileAt:tileCoordPoint];
    ///uint32_t a = [groundLayer tileGIDAt:tileCoordPoint];
    
    
    CGPoint userPositio = gameState.userPosition;
    
    CGPoint diff = ccpSub(tileCoordPoint, userPositio);

    NSLog(@"Tile Coordinate:%@",NSStringFromCGPoint(tileCoordPoint));
    NSLog(@"Player Coordinate:%@",NSStringFromCGPoint(userPositio));
    
    NSLog(@"User Difference:%@",NSStringFromCGPoint(diff));
    
    int destinationTileGID = [groundLayer tileGIDAt:tileCoordPoint];
    
    if ((diff.x >=-1 && diff.x<=1) && (diff.y>=-1 && diff.y<=1) ) {

        for (NSValue *monsterValue in gameState.monsterLocations) {
            
            CGPoint monsterPos = [monsterValue CGPointValue];
            
            CGPoint diff = ccpSub(monsterPos, tileCoordPoint);
            
            if (CGPointEqualToPoint(diff, CGPointZero)) {
                NSLog(@"User click on Monster File");
                
                if (!gameState.isTreasureBagFound) {

                    [hudLayer playerLostLife];
                }
                return;
            }
        }
        
        if (CGPointEqualToPoint(gameState.badgePosition, tileCoordPoint)) {
            gameState.isTreasureBagFound = YES;
        }
        
        unsigned int userPoints = 20;
        
        if (destinationTileGID != GRASS_TILE) {
            NSValue *grassLocation = [NSValue valueWithCGPoint:tileCoordPoint];
            
            [[gameState grassLocations] setObject:grassLocation forKey:NSStringFromCGPoint(tileCoordPoint)];
            [groundLayer setTileGID:GRASS_TILE at:tileCoordPoint];
            
        }else {
            
            userPoints =20 * -1;
            [[gameState grassLocations] removeObjectForKey:NSStringFromCGPoint(tileCoordPoint)];
            [groundLayer setTileGID:PLOW_TILE at:tileCoordPoint];
            
        }
        
        NSLog(@"Grass Location:%@",[gameState grassLocations]);
        CGPoint newPosition = [self locationFromTilePos:tileCoordPoint];
        [gameState setUserPosition:tileCoordPoint];
        
        CCMoveTo *action = [CCMoveTo actionWithDuration:1.2f position:newPosition];
        
        [userPlayer runAction:action];
        
        [gameState updateUserScore:userPoints];
        
        [hudLayer addUserPoints:gameState.userScore];
        
        int count  = [[gameState grassLocations] count];

        
        if(count == WIN_GAME_CRATERIA) {
            
            [gameState toJSONString];
            NSLog(@"Move To Next Level");
        }
        NSLog(@"Count:%d",count);
        
        [self applicationGoesIntoBackground];
    }
}


@end
