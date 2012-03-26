//
//  STwitterAccounts.h
//  STwitter
//
//  Created by Sinoru on 11. 10. 15..
//  Copyright (c) 2011년 Sinoru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

@interface STwitterAccounts : NSObject

+ (NSDictionary *)verifyCredentialsWithAccount:(ACAccount *)account includeEntities:(BOOL)includeEntities skipStatus:(BOOL)skipStatus error:(NSError **)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
+ (NSDictionary *)verifyCredentialsWithoAuthConsumerKey:oAuthConsumerKey oAuthConsumerSecret:oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret includeEntities:(BOOL)includeEntities skipStatus:(BOOL)skipStatus error:(NSError **)error;

@end
