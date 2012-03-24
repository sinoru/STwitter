//
//  STwitterFavorites.h
//  TweetBlast
//
//  Created by 재홍 강 on 11. 9. 9..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

@interface STwitterFavorites : NSObject {
    
}

+ (id)favoriteTweet:(NSNumber *)retweetID account:(ACAccount *)account includeEntities:(BOOL)includeEntities error:(NSError **)error;
+ (id)favoriteTweet:(NSNumber *)retweetID oAuthConsumerKey:oAuthConsumerKey oAuthConsumerSecret:oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret includeEntities:(BOOL)includeEntities error:(NSError **)error;

@end
