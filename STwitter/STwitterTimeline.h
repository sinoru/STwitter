//
//  STwitterTimeline.h
//  TweetBlast
//
//  Created by Sinoru on 11. 4. 4..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>


@interface STwitterTimeline : NSObject {
    
}

+ (id)getHomeTimelineWithAccount:(ACAccount *)account sinceID:(NSNumber *)sinceID maxID:(NSNumber *)maxID count:(NSNumber *)count trimUser:(BOOL)trimUser includeEntities:(BOOL)includeEntities error:(NSError **)error;
+ (id)getHomeTimelineWithOAuthConsumerKey:(NSString *)oAuthConsumerKey oAuthConsumerSecret:(NSString *)oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret sinceID:(NSNumber *)sinceID maxID:(NSNumber *)maxID count:(NSNumber *)count trimUser:(BOOL)trimUser includeEntities:(BOOL)includeEntities error:(NSError **)error;
+ (id)getMentionsWithOAuthConsumerKey:(NSString *)oAuthConsumerKey oAuthConsumerSecret:(NSString *)oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret sinceID:(NSNumber *)sinceID maxID:(NSNumber *)maxID count:(NSNumber *)count trimUser:(BOOL)trimUser includeRetweets:(BOOL)includeRetweets includeEntities:(BOOL)includeEntities error:(NSError **)error;
+ (id)getMentionsWithAccount:(ACAccount *)account sinceID:(NSNumber *)sinceID maxID:(NSNumber *)maxID count:(NSNumber *)count trimUser:(BOOL)trimUser includeRetweets:(BOOL)includeRetweets includeEntities:(BOOL)includeEntities error:(NSError **)error;

@end
