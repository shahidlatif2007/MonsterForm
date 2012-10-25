//
//  MFRequest.m
//  MonsterForm
//
//  Created by shahid.latif on 10/22/12.
//
//

#import "MFRequest.h"
#import "MFConstant.h"

@implementation MFRequest

@synthesize delegate;

-(id) init {

    self = [super init];
    
    if (self) {
        
    }
    return self;
}

-(id) initWithDelegate:(id) delegateObj {

    self = [super init];
    
    if (self) {
        
        self.delegate = delegateObj;

        requestSuccessfullyFinishSelector = @selector(requestCompletedSuccessfully:);
        requestFailedSelector = @selector(requestFailedWithError:);
    }
    return self;
}


-(void) downloadGameData {
    
    NSString *UID = [[[NSUserDefaults standardUserDefaults] objectForKey:uidKey] stringValue];
    
    int levelNumber = [[[NSUserDefaults standardUserDefaults] objectForKey:levelKey] intValue];
    
    if (levelNumber == 0 || levelNumber > 4) {
        levelNumber = 1;
    }
    
    
    //http://monsterfarm-mfs.appspot.com/getGame?uid=<xxx>
    
    NSURL *requestURL;
    
    
    if (!UID) {
        requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@loadInitial?gameLevel=%@&uid=%@",BASE_URL,[NSString stringWithFormat:@"%d",levelNumber],UID.length >0?UID:@"123"]];
        NSLog(@"Loading Initial Game");
    }else {
        requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@getGame?uid=%@",BASE_URL,UID.length >0?UID:@"123"]];
        NSLog(@"Loading Saved Game");
    }
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requestURL];
    
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    
    [request startAsynchronous];
    
    [request setDidFailSelector:requestFailedSelector];
    [request setDidFinishSelector:requestSuccessfullyFinishSelector];
}

-(void) saveGameState:(NSString*) gameState uid:(NSString*) uid {

    NSURL *gameSaveURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@saveGame?uid=%@",BASE_URL,uid]];
    
    ASIHTTPRequest *saveGameRequest = [ASIHTTPRequest requestWithURL:gameSaveURL];
    
    
    NSLog(@"%@",[NSData dataWithData:[gameState dataUsingEncoding:NSUTF8StringEncoding]]);
    [saveGameRequest setRequestMethod:@"POST"];
    [saveGameRequest appendPostData:[NSData dataWithData:[gameState dataUsingEncoding:NSUTF8StringEncoding]]];
    [saveGameRequest setDelegate:self];
    [saveGameRequest setDidFailSelector:requestFailedSelector];
    [saveGameRequest setDidFinishSelector:requestSuccessfullyFinishSelector];
    
    [saveGameRequest startAsynchronous];

}

-(void) requestFailedWithError:(ASIHTTPRequest *) request {


    if (delegate && [delegate respondsToSelector:@selector(mfRequestFailed:)]) {
        [delegate mfRequestFailed:request.error];
    }
}

-(void) requestCompletedSuccessfully:(ASIHTTPRequest*) request {

    if (delegate && [delegate respondsToSelector:@selector(mfRequestSuccess:)]) {
        [delegate mfRequestSuccess:request.responseData];
    }
}
@end
