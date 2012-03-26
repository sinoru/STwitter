//
//  STwitterTweets.h
//  STwitter
//
//  Created by Sinoru on 11. 3. 31..
//  Copyright 2011 Sinoru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>


@interface STwitterTweets : NSObject {
    
}

+ (id)statusUpdate:(NSString *)status account:(ACAccount *)account inReplyToStatusID:(NSNumber *)inReplyToStatusID error:(out NSError **)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
+ (id)statusUpdate:(NSString *)status oAuthConsumerKey:oAuthConsumerKey oAuthConsumerSecret:oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret inReplyToStatusID:(NSNumber *)inReplyToStatusID error:(out NSError **)error;
+ (id)retweetTweet:(NSNumber *)retweetID account:(ACAccount *)account includeEntities:(BOOL)includeEntities trimUser:(BOOL)trimUser error:(out NSError **)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
+ (id)retweetTweet:(NSNumber *)retweetID oAuthConsumerKey:oAuthConsumerKey oAuthConsumerSecret:oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret includeEntities:(BOOL)includeEntities trimUser:(BOOL)trimUser error:(out NSError **)error;

@end
