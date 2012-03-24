//
//  STwitterAccounts.h
//  TweetBlast
//
//  Created by 재홍 강 on 11. 10. 15..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

@interface STwitterAccounts : NSObject

+ (NSDictionary *)verifyCredentialsWithAccount:(ACAccount *)account includeEntities:(BOOL)includeEntities skipStatus:(BOOL)skipStatus error:(NSError **)error;
+ (NSDictionary *)verifyCredentialsWithoAuthConsumerKey:oAuthConsumerKey oAuthConsumerSecret:oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret includeEntities:(BOOL)includeEntities skipStatus:(BOOL)skipStatus error:(NSError **)error;

@end
