//
//  STwitterFavorites.h
//  STwitter
//
//  Created by Sinoru on 11. 9. 9..
//  Copyright (c) 2011년 Sinoru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

@interface STwitterFavorites : NSObject {
    
}

+ (id)favoriteTweet:(NSNumber *)retweetID account:(ACAccount *)account includeEntities:(BOOL)includeEntities error:(NSError **)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
+ (id)favoriteTweet:(NSNumber *)retweetID oAuthConsumerKey:oAuthConsumerKey oAuthConsumerSecret:oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret includeEntities:(BOOL)includeEntities error:(NSError **)error;

@end
