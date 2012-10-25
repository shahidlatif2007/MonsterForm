//
//  IntroLayer.h
//  MonsterForm
//
//  Created by shahid.latif on 10/18/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "MFRequestDelegate.h"
#import "MFRequest.h"
// HelloWorldLayer
@interface IntroLayer : CCLayer<MFRequestDelegate>
{
    MFRequest *request_;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
