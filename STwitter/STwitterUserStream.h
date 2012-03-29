//
//  STwitterUserStream.h
//  STwitter
//
//  Created by Sinoru on 11. 4. 9..
//  Copyright 2011 Sinoru. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STwitterRequest.h"

@protocol STwitterUserStreamDelegate <NSObject>
@required
- (void)accountIdentifier:(NSString *)identifier didReceiveUserStreamObject:(id)object;
- (void)accountIdentifier:(NSString *)identifier didFailWithError:(NSError *)error;
@end

@interface STwitterUserStream : NSObject

- (void)startUserStreamingWithAccount:(ACAccount *)account __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
- (void)startUserStreamingWithAccountIdentifier:(NSString *)identifier OAuthConsumerKey:(NSString *)OAuthConsumerKey OAuthConsumerSecret:(NSString *)OAuthConsumerSecret OAuthAccessToken:(NSString *)OAuthAccessToken OAuthAccessTokenSecret:(NSString *)OAuthAccessTokenSecret;
- (void)stopUserStreaming;

@property (nonatomic, readonly) NSString *accountIdentifier;
@property (nonatomic, strong) NSURLConnection *userStreamConnection;
@property (nonatomic, strong) NSMutableData *userStreamData;
@property (strong) id<STwitterUserStreamDelegate> delegate;

@end

extern NSString *const TweetBlastUserStreamConnectionDidFail;