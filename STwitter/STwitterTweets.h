//
//  STwitterTweets.h
//  TweetBlast
//
//  Created by Sinoru on 11. 3. 31..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>


@interface STwitterTweets : NSObject {
    
}

- (id)statusUpdate:(NSString *)status account:(ACAccount *)account inReplyToStatusID:(NSNumber *)inReplyToStatusID error:(NSError **)error;
- (id)statusUpdate:(NSString *)status oAuthConsumerKey:oAuthConsumerKey oAuthConsumerSecret:oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret inReplyToStatusID:(NSNumber *)inReplyToStatusID error:(NSError **)error;
- (id)retweetTweet:(NSNumber *)retweetID account:(ACAccount *)account includeEntities:(BOOL)includeEntities trimUser:(BOOL)trimUser error:(NSError **)error;
- (id)retweetTweet:(NSNumber *)retweetID oAuthConsumerKey:oAuthConsumerKey oAuthConsumerSecret:oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret includeEntities:(BOOL)includeEntities trimUser:(BOOL)trimUser error:(NSError **)error;

@end
