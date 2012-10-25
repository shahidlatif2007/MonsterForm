//
//  MFRequest.h
//  MonsterForm
//
//  Created by shahid.latif on 10/22/12.
//
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "MFRequestDelegate.h"
@interface MFRequest : NSObject {

    SEL requestSuccessfullyFinishSelector;
    SEL requestFailedSelector;
    
}

@property (nonatomic, assign) id delegate;

-(void) saveGameState:(NSString*) gameState uid:(NSString*) uid;

-(void) downloadGameData;
-(id) initWithDelegate:(id) delegateObj;

@end
