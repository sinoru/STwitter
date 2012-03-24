//
//  STwitterTweets+media.h
//  STwitter
//
//  Created by 강 재홍 on 12. 3. 5..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "STwitterTweets.h"

@interface STwitterTweets (media)

+ (id)statusUpdate:(NSString *)status withMediaDatas:(NSArray *)mediaDatas mediaTypes:(NSArray *)mediaTypes account:(ACAccount *)account inReplyToStatusID:(NSNumber *)inReplyToStatusID error:(out NSError **)error;
+ (id)statusUpdate:(NSString *)status withMediaDatas:(NSArray *)mediaDatas mediaTypes:(NSArray *)mediaTypes oAuthConsumerKey:oAuthConsumerKey oAuthConsumerSecret:oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret inReplyToStatusID:(NSNumber *)inReplyToStatusID error:(out NSError **)error;

@end
