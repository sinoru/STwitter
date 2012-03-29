//
//  STwitterTimeline.h
//  STwitter
//
//  Created by Sinoru on 11. 4. 4..
//  Copyright 2011 Sinoru. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STwitterRequest.h"

@interface STwitterTimeline : NSObject {
    
}

+ (id)getHomeTimelineWithAccount:(ACAccount *)account sinceID:(NSNumber *)sinceID maxID:(NSNumber *)maxID count:(NSNumber *)count trimUser:(BOOL)trimUser includeEntities:(BOOL)includeEntities error:(NSError **)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
+ (id)getHomeTimelineWithOAuthConsumerKey:(NSString *)OAuthConsumerKey OAuthConsumerSecret:(NSString *)OAuthConsumerSecret OAuthAccessToken:(NSString *)OAuthAccessToken OAuthAccessTokenSecret:(NSString *)OAuthAccessTokenSecret sinceID:(NSNumber *)sinceID maxID:(NSNumber *)maxID count:(NSNumber *)count trimUser:(BOOL)trimUser includeEntities:(BOOL)includeEntities error:(NSError **)error;
+ (id)getMentionsWithAccount:(ACAccount *)account sinceID:(NSNumber *)sinceID maxID:(NSNumber *)maxID count:(NSNumber *)count trimUser:(BOOL)trimUser includeRetweets:(BOOL)includeRetweets includeEntities:(BOOL)includeEntities error:(NSError **)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
+ (id)getMentionsWithOAuthConsumerKey:(NSString *)OAuthConsumerKey OAuthConsumerSecret:(NSString *)OAuthConsumerSecret OAuthAccessToken:(NSString *)OAuthAccessToken OAuthAccessTokenSecret:(NSString *)OAuthAccessTokenSecret sinceID:(NSNumber *)sinceID maxID:(NSNumber *)maxID count:(NSNumber *)count trimUser:(BOOL)trimUser includeRetweets:(BOOL)includeRetweets includeEntities:(BOOL)includeEntities error:(NSError **)error;

@end
