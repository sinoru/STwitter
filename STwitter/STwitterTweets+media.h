//
//  STwitterTweets+media.h
//  STwitter
//
//  Created by Sinoru on 12. 3. 5..
//  Copyright (c) 2012년 Sinoru. All rights reserved.
//

#import "STwitterTweets.h"

@interface STwitterTweets (media)

+ (id)statusUpdate:(NSString *)status withMediaDatas:(NSArray *)mediaDatas mediaTypes:(NSArray *)mediaTypes account:(ACAccount *)account inReplyToStatusID:(NSNumber *)inReplyToStatusID error:(out NSError **)error;
+ (id)statusUpdate:(NSString *)status withMediaDatas:(NSArray *)mediaDatas mediaTypes:(NSArray *)mediaTypes oAuthConsumerKey:oAuthConsumerKey oAuthConsumerSecret:oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret inReplyToStatusID:(NSNumber *)inReplyToStatusID error:(out NSError **)error;

@end
