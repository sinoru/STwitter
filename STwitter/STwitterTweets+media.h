//
//  STwitterTweets+media.h
//  STwitter
//
//  Created by Sinoru on 12. 3. 5..
//  Copyright (c) 2012년 Sinoru. All rights reserved.
//

#import "STwitterTweets.h"

#import "STwitterRequest.h"

@interface STwitterTweets (media)

+ (id)statusUpdate:(NSString *)status withMediaDatas:(NSArray *)mediaDatas mediaTypes:(NSArray *)mediaTypes account:(ACAccount *)account inReplyToStatusID:(NSNumber *)inReplyToStatusID error:(out NSError **)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);

+ (id)statusUpdate:(NSString *)status withMediaDatas:(NSArray *)mediaDatas mediaTypes:(NSArray *)mediaTypes OAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret OAuthAccessToken:(NSString *)OAuthAccessToken OAuthAccessTokenSecret:(NSString *)OAuthAccessTokenSecret inReplyToStatusID:(NSNumber *)inReplyToStatusID error:(out NSError **)error;

@end
