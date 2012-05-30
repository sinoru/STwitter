//
//  STwitterAccounts.h
//  STwitter
//
//  Created by Sinoru on 11. 10. 15..
//  Copyright (c) 2011년 Sinoru. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STwitterRequest.h"

@interface STwitterAccounts : NSObject

+ (NSDictionary *)verifyCredentialsWithAccount:(ACAccount *)account includeEntities:(BOOL)includeEntities skipStatus:(BOOL)skipStatus error:(NSError **)error __OSX_AVAILABLE_STARTING(__MAC_10_8,__IPHONE_5_0);
+ (NSDictionary *)verifyCredentialsWithOAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret OAuthAccessToken:(NSString *)OAuthAccessToken OAuthAccessTokenSecret:(NSString *)OAuthAccessTokenSecret includeEntities:(BOOL)includeEntities skipStatus:(BOOL)skipStatus error:(NSError **)error;

@end
