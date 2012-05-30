//
//  STwitterDirectMessages.h
//  STwitter
//
//  Created by Sinoru on 12. 3. 29..
//  Copyright (c) 2012년 Sinoru. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STwitterRequest.h"

@interface STwitterDirectMessages : NSObject

+ (id)getDirectMessagesWithAccount:(ACAccount *)account sinceID:(NSNumber *)sinceID maxID:(NSNumber *)maxID count:(NSNumber *)count includeEntities:(BOOL)includeEntities skipStatus:(BOOL)skipStatus error:(NSError **)error __OSX_AVAILABLE_STARTING(__MAC_10_8,__IPHONE_5_0);
+ (id)getDirectMessagesWithOAuthConsumerKey:(NSString *)OAuthConsumerKey OAuthConsumerSecret:(NSString *)OAuthConsumerSecret OAuthAccessToken:(NSString *)OAuthAccessToken OAuthAccessTokenSecret:(NSString *)OAuthAccessTokenSecret sinceID:(NSNumber *)sinceID maxID:(NSNumber *)maxID count:(NSNumber *)count includeEntities:(BOOL)includeEntities skipStatus:(BOOL)skipStatus error:(NSError **)error;

@end
