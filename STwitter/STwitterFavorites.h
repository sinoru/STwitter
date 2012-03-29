//
//  STwitterFavorites.h
//  STwitter
//
//  Created by Sinoru on 11. 9. 9..
//  Copyright (c) 2011년 Sinoru. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STwitterRequest.h"

@interface STwitterFavorites : NSObject

+ (id)favoriteTweet:(NSNumber *)tweetID account:(ACAccount *)account includeEntities:(BOOL)includeEntities error:(NSError **)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
+ (id)favoriteTweet:(NSNumber *)tweetID OAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret OAuthAccessToken:(NSString *)OAuthAccessToken OAuthAccessTokenSecret:(NSString *)OAuthAccessTokenSecret includeEntities:(BOOL)includeEntities error:(NSError **)error;

@end
