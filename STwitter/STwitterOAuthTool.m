//
//  STwitterOAuthTool.m
//  TweetBlast
//
//  Created by Sinoru on 11. 4. 4..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "STwitterOAuthTool.h"

#import <CommonCrypto/CommonHMAC.h>
#import "NSString (RFC3875PercentEscapes).h"
#import "NSData+Base64.h"


@implementation STwitterOAuthTool

- (NSString *)generateUUID
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    NSString *uuidString = [NSString stringWithFormat:@"%@", uuidStr];
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return uuidString;
}

- (NSString *)generateOAuthSignature:(NSDictionary *)oAuthSignatureDict httpMethod:(NSString *)httpMethod apiURL:(NSURL *)apiURL oAuthConsumerSecret:oAuthConsumerSecret oAuthTokenSecret:(NSString *)oAuthTokenSecret
{
    NSMutableArray *parts = [NSMutableArray array];
    NSString *part;
    id key;
    id value;
    
    for(key in oAuthSignatureDict)
    {
        @autoreleasepool {
            value = [oAuthSignatureDict objectForKey:key];
            part = [NSString stringWithFormat:@"%@%@%@", [key stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding], @"\%3D", [value stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [parts addObject:part];
        }
    }
    
    [parts sortUsingSelector:@selector(compare:)];
    
    if (oAuthTokenSecret == nil)
        oAuthTokenSecret = [NSString stringWithString:@""];
    
    NSString *signatureKey = [NSString stringWithFormat:@"%@&%@", oAuthConsumerSecret, oAuthTokenSecret];
    NSArray *signatureArray = [NSArray arrayWithObjects:httpMethod, [[apiURL absoluteString] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding], [parts componentsJoinedByString:@"\%26"], nil];
    
    const char *cKey  = [signatureKey cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [[signatureArray componentsJoinedByString:@"&"] cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *oAuthSignature = [NSString stringWithString:[HMAC base64EncodedString]];
    
    return oAuthSignature;
    
}

- (NSString *)generateHTTPAuthorizationHeader:(NSDictionary *)oAuthArgumentDict
{
    NSMutableArray *parts = [NSMutableArray array];
    NSString *part;
    id key;
    id value;
    
    for(key in oAuthArgumentDict)
    {
        @autoreleasepool {
            value = [oAuthArgumentDict objectForKey:key];
            part = [NSString stringWithFormat:@"%@=\"%@\"", [key stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding], [value stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [parts addObject:part];
        }
    }
    
    [parts sortUsingSelector:@selector(compare:)];
    
    NSMutableString *oAuthArgumentMutableString = [NSMutableString stringWithString:@"OAuth "];
    [oAuthArgumentMutableString appendString:[parts componentsJoinedByString:@", "]];
    
    return oAuthArgumentMutableString;
}

- (NSString *)generateHTTPBody:(NSDictionary *)httpBodyParameterDict
{
    NSMutableArray *parts = [NSMutableArray array];
    
    for(id key in httpBodyParameterDict)
    {
        @autoreleasepool {
            NSString *part;
            id value;
            value = [httpBodyParameterDict objectForKey:key];
            part = [NSString stringWithFormat:@"%@=%@", key, value];
            // part = [NSString stringWithFormat:@"%@=%@", key, value];
            [parts addObject:part];
        }
    }
    
    [parts sortUsingSelector:@selector(compare:)];
    
    return [parts componentsJoinedByString:@"&"];
}

@end
