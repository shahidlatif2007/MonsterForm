//
//  FlowerSprite.m
//  MonsterForm
//
//  Created by shahid.latif on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MFSprite.h"


@implementation MFSprite

-(void) removeSprite {

    [self removeFromParentAndCleanup:YES];
}

-(void) showAnimationOnSprite {

    CCFadeIn *fadeInAnimation = [CCFadeIn actionWithDuration:1.0];
    CCFadeOut *fadeOutAnimation = [CCFadeOut actionWithDuration:1.0];
    
    CCCallFuncND *action = [CCCallFuncND actionWithTarget:self selector:@selector(removeSprite) data:nil];
    
    CCSequence *sequenceAction = [CCSequence actions:fadeInAnimation,fadeOutAnimation,action, nil];
    
    [self runAction:sequenceAction];
    
}

@end
