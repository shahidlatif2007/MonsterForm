//
//  GenericAnimation.m
//  MonsterForm
//
//  Created by shahid.latif on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GenericAnimation.h"


@implementation GenericAnimation

-(void) dealloc {
    [animArray release];
    [super dealloc];
}

-(id) initWithMonsterPlistFileNameOnLayer:(CCLayer*)layer {

    self = [super init];
    
    if(self) {
    
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"monsterAnim.plist"];
        
        CCSpriteBatchNode *bearBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"monsterAnim.png"];
        [layer addChild:bearBatchNode];

        
        animArray = [[NSMutableArray alloc] init];
        
        for (unsigned int index = 0 ; index < 2 ; index++) {
            
            NSString *frameName = [NSString stringWithFormat:@"m2-%d.png",index + 1];
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
            
            [animArray addObject:frame];
        }
        
    }
   
    return self;
}

-(CCSprite*) animationSprite {

    return  [CCSprite spriteWithSpriteFrame:[animArray objectAtIndex:0]];
}

-(void) removeSprite:(CCSprite*) sprite {
    
    [sprite removeFromParentAndCleanup:YES];
}

-(void) runActionOnSprite:(CCSprite *) sprite {


    CCAnimation *anim = [CCAnimation animationWithSpriteFrames:animArray delay:0.5f];
    CCAnimate *action = [CCAnimate actionWithAnimation:anim];
    CCSequence *seq = [CCSequence actions:[CCRepeat actionWithAction:action times:2],[CCCallFuncND actionWithTarget:self selector:@selector(removeSprite:) data:sprite], nil];
    [sprite runAction:seq];
}





@end
