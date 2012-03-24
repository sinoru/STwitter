//
//  STwitterOAuth.h
//  TweetBlast
//
//  Created by Sinoru on 11. 3. 29..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface STwitterOAuth : NSObject {
    
}

+ (NSDictionary *)requestRequestTokenWithOAuthConsumerKey:oAuthConsumerKey oAuthConsumerSecret:oAuthConsumerSecret;
+ (NSURLRequest *)authorizeURLRequestWithRequestToken:(NSString *)token;
+ (NSDictionary *)exchangeRequestTokenToAccessTokenWithOAuthConsumerKey:oAuthConsumerKey oAuthConsumerSecret:oAuthConsumerSecret oAuthRequestToken:(NSString *)oAuthRequestToken oAuthRequestTokenSecret:(NSString *)oAuthRequestTokenSecret oAuthVerifier:oAuthVerifier;

@end
