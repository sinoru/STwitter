//
//  STwitterOAuthTool.h
//  STwitter
//
//  Created by Sinoru on 11. 4. 4..
//  Copyright 2011 Sinoru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>

@interface STwitterOAuthTool : NSObject {
    
}

+ (NSString *)generateUUID;
+ (NSString *)generateOAuthSignature:(NSDictionary *)httpBodyDict httpMethod:(NSString *)httpMethod apiURL:(NSURL *)apiURL oAuthConsumerSecret:oAuthConsumerSecret oAuthTokenSecret:(NSString *)oAuthTokenSecret;
+ (NSString *)generateHTTPAuthorizationHeader:(NSDictionary *)oAuthArgumentDict;
+ (NSString *)generateHTTPBodyString:(NSDictionary *)httpBodyParameterDict;
+ (NSData *)generateHTTPBodyDataWithMultiPartDatas:(NSArray *)multiPartDatas multiPartNames:(NSArray *)multiPartNames multiPartTypes:(NSArray *)multiPartTypes boundary:(NSString *)boundary ;

@end
