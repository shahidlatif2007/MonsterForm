//
//  HelloWorldLayer.m
//  MonsterForm
//
//  Created by shahid.latif on 10/18/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "MFConstant.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
    
    
    
	// add layer as a child to scene
	[scene addChild: layer];
	
    
	// return the scene
	return scene;
}

-(void) debugMenu {

    
    CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Along X Axis" block:^(id sender) {
        CGPoint mapPosition = map.position;
        mapPosition.x += 4;
        [map setPosition:mapPosition];
        NSLog(@"Final Map Position:%@",NSStringFromCGPoint(map.position));
    }
                                   ];
    
    // Leaderboard Menu Item using blocks
    CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Along Y Axis" block:^(id sender) {
        
        CGPoint mapPosition = map.position;
        mapPosition.y += 4;
        [map setPosition:mapPosition];
        NSLog(@"Final Map Position along Y Axis:%@",NSStringFromCGPoint(map.position));

     }
                                   ];
    
    CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
    
    [menu alignItemsHorizontallyWithPadding:20];
    [menu setPosition:ccp( 480/2, 320/2 - 50)];
    
    // Add the menu to the layer
    [self addChild:menu];

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
    
    
    
    CGPoint pixelPos = CGPointMake((map.tileSize.width * map.scaleX /2.0) / CC_CONTENT_SCALE_FACTOR()  * ( map.mapSize.width  + tilePos.x - tilePos.y - 1),
                                   (map.tileSize.height * map.scaleY/2.0 ) / CC_CONTENT_SCALE_FACTOR() * (( map.mapSize.height * 2 - tilePos.x - tilePos.y) -1) );
    //May be map is not at (0,0), so add its current position
    
    pixelPos = ccpAdd(pixelPos, map.position);
    pixelPos.y += map.tileSize.height/4.0f;
    pixelPos.x += map.tileSize.width/4.0f;
    
    return pixelPos;
    
}



// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		testPos = ccp(0, 0);
    
        
        CCSprite *background = [CCSprite spriteWithFile:@"bg.jpg"];
        
        [background setPosition:ccp(480/2.0f, 320/2.0f)];
		
		[self addChild:background];
  
        map = [CCTMXTiledMap tiledMapWithTMXFile:@"MonsterFormTileMap.tmx"];
        [self addChild:map];
        [map setPosition:ccp(4 ,24)];
        //[self debugMenu];

        self.isTouchEnabled = YES;
        NSLog(@"Map Position:%@",NSStringFromCGPoint(map.position));
        
        //CCTMXLayer *layer = [map layerNamed:@"GroundLayer"];
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
//                    if (properties) {
//                        
//                        CGPoint pos = [self locationFromTilePos:ccp(x,y)];
//
//                        CCSprite *sprite1 = [CCSprite spriteWithFile:@"player.png"];
//                        [sprite1 setPosition:pos];
//                        [self addChild:sprite1 z:200];
//                        
//                        testPos = pos;
//                    }
//                }
//                
//            }
//
//        }
       
        
        userPlayer = [CCSprite spriteWithFile:@"player.png"];
        
        CGPoint playerPosition = [self locationFromTilePos:ccp(0,0)];
        
        [userPlayer setPosition:playerPosition];
        [self addChild:userPlayer];
    
    
        hudLayer = [HudLayer node];
        [self addChild:hudLayer];
        
        animation = [[GenericAnimation alloc] initWithMonsterPlistFileNameOnLayer:self];
        
        CCSprite *animSprite = [animation animationSprite];
        [animSprite setPosition:playerPosition];
        [self addChild:animSprite];
        
        [animation runActionOnSprite:animSprite];
        

  
	}
	return self;
}




-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    if (userPlayer.numberOfRunningActions != 0) {
        return;
    }
    UITouch *touch = [touches anyObject];
    
    CGPoint touchViewPoint = [touch locationInView:[touch view]];
    
    CGPoint convertedPoint = [[CCDirector sharedDirector] convertToGL:[self convertToNodeSpace:touchViewPoint]];
    
    CGPoint tileCoordPoint = [self tilePositionFromLocation:convertedPoint];
    
    

    //[groundLayer removeTileAt:tileCoordPoint];
    ///uint32_t a = [groundLayer tileGIDAt:tileCoordPoint];
    
    
    CGPoint userPositio = [self tilePositionFromLocation:userPlayer.position];

    CGPoint diff = ccpSub(tileCoordPoint, userPositio);
    
    NSLog(@"User Difference:%@",NSStringFromCGPoint(diff));

    
    if ((diff.x >=-1 && diff.x<=1) || (diff.y>=0 && diff.y<=-1)) {

        CCTMXLayer *groundLayer = [map layerNamed:@"GroundLayer"];
        [groundLayer setTileGID:2 at:tileCoordPoint];
        
        CGPoint newPosition = [self locationFromTilePos:tileCoordPoint];
    
        CCMoveTo *action = [CCMoveTo actionWithDuration:1.2f position:newPosition];
        
        [userPlayer runAction:action];
        
        [hudLayer addUserPoints:20];
        
        CCSprite *animSprite = [animation animationSprite];
        [animSprite setPosition:newPosition];
        [self addChild:animSprite];
        
        [animation runActionOnSprite:animSprite];

    }
}


-(void) draw {
    
    
    glLineWidth(4.0f);
    glColorMask(1, 1, 1, 1);

    
    ccDrawLine(ccp(0,0),testPos);

    
    
    glLineWidth(1.0f);
    glColorMask(1, 1, 1, 1);
    
    
    
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
