//
//  IntroLayer.m
//  MonsterForm
//
//  Created by shahid.latif on 10/18/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "HelloWorldLayer.h"
#import "CustomParticleSystem.h"
#import "MFRequest.h"
#import "GameLayer.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void) dealloc {

    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [super dealloc];

}

-(void) loadGameData {

    request_ = [[MFRequest alloc] initWithDelegate:self];

    [request_ downloadGameData];
}

-(id) init {
    
    self = [super init];
    
    if (self) {
        
        CGSize winSize = CGSizeMake(480, 320);
        [[CCDirector sharedDirector] winSize];
        
        CCSprite *background = [CCSprite spriteWithFile:@"bg.jpg"];
        [background setPosition:ccp(winSize.width/2.0f, winSize.height/2.0f)];
        [self addChild:background];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"fairy.plist"];
        
        CCSpriteBatchNode *fairyBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"fairy.png"];
        [self addChild:fairyBatchNode];
        
        //Gather the list of frames
        
        NSMutableArray *animArray = [NSMutableArray array];
        
        for (unsigned int index = 0 ; index < 2 ; index++) {
            
            NSString *frameName = [NSString stringWithFormat:@"fairy%d.png",index + 1];
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
            
            [animArray addObject:frame];
        }
        
        CCAnimation *anim = [CCAnimation animationWithSpriteFrames:animArray delay:0.1];
        
        CCSprite *fairy = [CCSprite spriteWithSpriteFrame:[animArray objectAtIndex:0]];
        [fairy setPosition:ccp(winSize.width/2.0f, winSize.height/2.0f)];
        
        CCFiniteTimeAction *action = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:anim] times:20];
        CCFiniteTimeAction *moveTOPoint1 = [CCMoveTo actionWithDuration:4.0f position:CGPointMake(winSize.width, winSize.height/2.0f)];
        CCFiniteTimeAction *moveTOPoint2 = [CCMoveTo actionWithDuration:4.0f position:CGPointMake(0, winSize.height/2.0f)];
    
//        CCCallFuncN *moveToNextScene = [CCCallFuncN actionWithTarget:self selector:@selector(animationSequenceOver)];
        CCSpawn *seq = [CCSpawn actions:action,moveTOPoint1,moveTOPoint2, nil];
        
        CCSequence *seq1 = [CCSequence actions:seq,moveTOPoint1, nil];
        
        [self addChild:fairy];
        
        NSLog(@"ANimation Started");
        [fairy runAction:[CCRepeatForever actionWithAction:seq1]];
        
        CCLabelTTF *levelLabel = [CCLabelTTF labelWithString:@"Level 1" fontName:@"Arial" fontSize:20.0f];
        [levelLabel setPosition:CGPointMake(30, fairy.boundingBox.size.height)];
        
        [fairy addChild:levelLabel];
        
        CCFiniteTimeAction *moveTolabelAction = [CCMoveTo actionWithDuration:2.0 position:CGPointMake(30,fairy.boundingBox.size.height + 50)];
        
        CCFiniteTimeAction *moveTolabelAction1 = [CCMoveTo actionWithDuration:2.0 position:CGPointMake(30,fairy.boundingBox.size.height)];

        CCSequence *sequenceLabelAction = [CCSequence actions:moveTolabelAction,moveTolabelAction1, nil];
        
        
        [levelLabel runAction:[CCRepeatForever actionWithAction:sequenceLabelAction]];

        //How to use particle System
        CCParticleFlower *flowerParticle = [[[CCParticleFlower alloc] init] autorelease];
        [flowerParticle setPosition:ccp(0, 0)];
       // [fairy addChild:flowerParticle];
        
        CCParticleSystem *customParticleSystem = [CustomParticleSystem particle];
        [customParticleSystem setPosition:ccp(0, 0)];
        [fairy addChild:customParticleSystem];
        
        
        CCParticleSnow *snow = [[CCParticleSnow alloc] init];
        
        [snow setPosition:CGPointMake(200.0f, 320.0f)];
        [self addChild:snow];
        

        [self schedule:@selector(loadGameData) interval:4.0f repeat:0.0f delay:0.0f];
    }
    return self;

}

// 
-(void) onEnter {
    
	[super onEnter];
}

-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] withColor:ccWHITE]];
}

-(void) mfRequestSuccess:(NSData *)data {
    
    NSLog(@"User Data:%@",[NSString stringWithUTF8String:[data bytes]]);
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer sceneWithGameState:data] withColor:ccWHITE]];
}

-(void) mfRequestFailed:(NSError *)error {
    
    NSLog(@"Request FAiled With Error:%@",error);
}
@end
