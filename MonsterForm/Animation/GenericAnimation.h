//
//  GenericAnimation.h
//  MonsterForm
//
//  Created by shahid.latif on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GenericAnimation : NSObject {
 

    
    NSMutableArray *animArray;
    
}

-(CCSprite*) animationSprite;

-(id) initWithMonsterPlistFileNameOnLayer:(CCLayer*)layer;

-(void) runActionOnSprite:(CCSprite *) sprite;

@end
