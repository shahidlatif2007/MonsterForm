//
//  MFRequestDelegate.h
//  MonsterForm
//
//  Created by shahid.latif on 10/24/12.
//
//

#import <Foundation/Foundation.h>

@protocol MFRequestDelegate <NSObject>

@optional
- (void) mfRequestSuccess:(NSData*)data;
- (void) mfRequestFailed:(NSError*)error;

@end
