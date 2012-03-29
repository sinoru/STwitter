//
//  STwitterTweets.h
//  STwitter
//
//  Created by Sinoru on 11. 3. 31..
//  Copyright 2011 Sinoru. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STwitterRequest.h"


@interface STwitterTweets : NSObject {
    
}

+ (id)statusUpdate:(NSString *)status account:(ACAccount *)account inReplyToStatusID:(NSNumber *)inReplyToStatusID error:(out NSError **)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
+ (id)statusUpdate:(NSString *)status OAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret OAuthAccessToken:(NSString *)OAuthAccessToken OAuthAccessTokenSecret:(NSString *)OAuthAccessTokenSecret inReplyToStatusID:(NSNumber *)inReplyToStatusID error:(out NSError **)error;
+ (id)retweetTweet:(NSNumber *)tweetID account:(ACAccount *)account includeEntities:(BOOL)includeEntities trimUser:(BOOL)trimUser error:(out NSError **)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
+ (id)retweetTweet:(NSNumber *)tweetID OAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret OAuthAccessToken:(NSString *)OAuthAccessToken OAuthAccessTokenSecret:(NSString *)OAuthAccessTokenSecret includeEntities:(BOOL)includeEntities trimUser:(BOOL)trimUser error:(out NSError **)error;

@end
