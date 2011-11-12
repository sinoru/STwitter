//
//  STwitterUserStream.h
//  TweetBlast
//
//  Created by Sinoru on 11. 4. 9..
//  Copyright 2011 Sinoru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "SBJson.h"
#import "STwitterOAuthTool.h"

@protocol STwitterUserStreamDelegate <NSObject>

@required
- (void)accountIdentifier:(NSString *)identifier didReceiveUserStreamObject:(id)object;
- (void)accountIdentifier:(NSString *)identifier didFailWithError:(NSError *)error;

@end

@interface STwitterUserStream : NSObject <NSURLConnectionDelegate ,SBJsonStreamParserAdapterDelegate> {
    NSURLConnection *userStreamConnection;
    NSMutableData *userStreamData;
    
    ACAccount *account;
    NSString *accountIdentifier;
    
    SBJsonStreamParser *parser;
    SBJsonStreamParserAdapter *adapter;
}

- (void)startUserStreamingWithAccount:(ACAccount *)account;
- (void)startUserStreamingWithAccountIdentifier:(NSString *)identifier OAuthConsumerKey:(NSString *)oAuthConsumerKey oAuthConsumerSecret:(NSString *)oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret;
- (void)stopUserStreaming;

@property (nonatomic, strong) NSURLConnection *userStreamConnection;
@property (nonatomic, strong) NSMutableData *userStreamData;
@property (strong) id<STwitterUserStreamDelegate> delegate;

@end

extern NSString *const TweetBlastUserStreamConnectionDidFail;