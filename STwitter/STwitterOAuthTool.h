//
//  STwitterOAuthTool.h
//  TweetBlast
//
//  Created by Sinoru on 11. 4. 4..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface STwitterOAuthTool : NSObject {
    
}

- (NSString *)generateUUID;
- (NSString *)generateOAuthSignature:(NSDictionary *)httpBodyDict httpMethod:(NSString *)httpMethod apiURL:(NSURL *)apiURL oAuthConsumerSecret:oAuthConsumerSecret oAuthTokenSecret:(NSString *)oAuthTokenSecret;
- (NSString *)generateHTTPAuthorizationHeader:(NSDictionary *)oAuthArgumentDict;
- (NSString *)generateHTTPBody:(NSDictionary *)httpBodyParameterDict;

@end
