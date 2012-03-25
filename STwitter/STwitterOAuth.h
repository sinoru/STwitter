//
//  STwitterOAuth.h
//  STwitter
//
//  Created by Sinoru on 11. 3. 29..
//  Copyright 2011 Sinoru. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface STwitterOAuth : NSObject {
    
}

+ (NSDictionary *)getRequestTokenWithOAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret;
+ (NSURLRequest *)getUserAuthorizeURLRequestWithRequestToken:(NSString *)token;
+ (NSURLRequest *)getUserAuthorizeURLRequestWithRequestToken:(NSString *)token forceLogin:(BOOL)forceLogin screenName:(NSString *)screenName;
+ (NSDictionary *)exchangeRequestTokenForAccessTokenWithOAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret OAuthRequestToken:(NSString *)OAuthRequestToken OAuthRequestTokenSecret:(NSString *)OAuthRequestTokenSecret OAuthVerifier:OAuthVerifier;
+ (NSDictionary *)exchangeRequestTokenForAccessTokenWithOAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret OAuthRequestToken:(NSString *)OAuthRequestToken OAuthRequestTokenSecret:(NSString *)OAuthRequestTokenSecret xAuthUsername:(NSString *)xAuthUsername xAuthPassword:(NSString *)xAuthPassword;

@end
