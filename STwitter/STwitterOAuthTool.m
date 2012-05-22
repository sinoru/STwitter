//
//  STwitterOAuthTool.m
//  STwitter
//
//  Created by Sinoru on 11. 4. 4..
//  Copyright 2011 Sinoru. All rights reserved.
//

#import "STwitterOAuthTool.h"

#import "NSString (RFC3986PercentEscapes).h"
#import "NSData+Base64.h"


@implementation STwitterOAuthTool

+ (NSString *)generateUUID
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

+ (NSString *)generateOAuthSignature:(NSDictionary *)oAuthSignatureDict httpMethod:(NSString *)httpMethod apiURL:(NSURL *)apiURL oAuthConsumerSecret:oAuthConsumerSecret oAuthTokenSecret:(NSString *)oAuthTokenSecret
{
    NSMutableArray *parts = [NSMutableArray array];
    NSString *part;
    id key;
    id value;
    
    for(key in oAuthSignatureDict)
    {
        @autoreleasepool {
            value = [oAuthSignatureDict objectForKey:key];
            part = [NSString stringWithFormat:@"%@=%@", ([key isKindOfClass:[NSString class]] ? [key stringByAddingRFC3986PercentEscapesUsingEncoding:NSUTF8StringEncoding] : key), ([value isKindOfClass:[NSString class]] ? [value stringByAddingRFC3986PercentEscapesUsingEncoding:NSUTF8StringEncoding] : value)];
            [parts addObject:part];
        }
    }
    
    [parts sortUsingSelector:@selector(compare:)];
    
    if (oAuthTokenSecret == nil)
        oAuthTokenSecret = @"";
    
    NSString *signatureKey = [NSString stringWithFormat:@"%@&%@", oAuthConsumerSecret, oAuthTokenSecret];
    NSArray *signatureArray = [NSArray arrayWithObjects:httpMethod, [[apiURL absoluteString] stringByAddingRFC3986PercentEscapesUsingEncoding:NSUTF8StringEncoding], [[parts componentsJoinedByString:@"&"] stringByAddingRFC3986PercentEscapesUsingEncoding:NSUTF8StringEncoding], nil];
    NSString *signatureString = [signatureArray componentsJoinedByString:@"&"];
    
    const char *cKey  = [signatureKey cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [signatureString cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *oAuthSignature = [NSString stringWithString:[HMAC base64EncodedString]];
    
    return oAuthSignature;
    
}

+ (NSString *)generateHTTPAuthorizationHeader:(NSDictionary *)oAuthArgumentDict
{
    NSMutableArray *parts = [NSMutableArray array];
    NSString *part;
    id key;
    id value;
    
    for(key in oAuthArgumentDict)
    {
        @autoreleasepool {
            value = [oAuthArgumentDict objectForKey:key];
            part = [NSString stringWithFormat:@"%@=\"%@\"", [key stringByAddingRFC3986PercentEscapesUsingEncoding:NSUTF8StringEncoding], [value stringByAddingRFC3986PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [parts addObject:part];
        }
    }
    
    [parts sortUsingSelector:@selector(compare:)];
    
    NSMutableString *oAuthArgumentMutableString = [NSMutableString stringWithString:@"OAuth "];
    [oAuthArgumentMutableString appendString:[parts componentsJoinedByString:@", "]];
    
    return oAuthArgumentMutableString;
}

+ (NSString *)generateHTTPOAuthHeaderStringWithOAuthConsumerKey:(NSString *)OAuthConsumerKey OAuthConsumerSecret:(NSString *)OAuthConsumerSecret OAuthToken:(NSString *)OAuthToken OAuthTokenSecret:(NSString *)OAuthTokenSecret OAuthSignatureMethod:(NSString *)OAuthSignatureMethod OAuthVersion:(NSString *)OAuthVersion httpMethod:(NSString *)httpMethod apiURL:(NSURL *)apiURL parameters:(NSDictionary *)parameters
{
    NSString *OAuthNonce = [STwitterOAuthTool generateUUID];
    NSString *OAuthTimestamp = [NSString stringWithFormat:@"%i" , [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] intValue]];
    
    NSMutableDictionary *OAuthArgumentDict = [[NSMutableDictionary alloc] init];
    
    [OAuthArgumentDict setObject:OAuthConsumerKey forKey:@"oauth_consumer_key"];
    [OAuthArgumentDict setObject:OAuthNonce forKey:@"oauth_nonce"];
    [OAuthArgumentDict setObject:OAuthSignatureMethod forKey:@"oauth_signature_method"];
    [OAuthArgumentDict setObject:OAuthToken forKey:@"oauth_token"];
    [OAuthArgumentDict setObject:OAuthTimestamp forKey:@"oauth_timestamp"];
    [OAuthArgumentDict setObject:OAuthVersion forKey:@"oauth_version"];
    
    NSMutableDictionary *OAuthSignatureDict = [[NSMutableDictionary alloc] initWithDictionary:OAuthArgumentDict];
    [OAuthSignatureDict addEntriesFromDictionary:parameters];
    
    [OAuthArgumentDict setObject:[self generateOAuthSignature:OAuthSignatureDict httpMethod:httpMethod apiURL:apiURL oAuthConsumerSecret:OAuthConsumerSecret oAuthTokenSecret:OAuthTokenSecret] forKey:@"oauth_signature"];
    
    NSMutableArray *parts = [NSMutableArray array];
    NSString *part;
    id key;
    id value;
    
    for(key in OAuthArgumentDict)
    {
        @autoreleasepool {
            value = [OAuthArgumentDict objectForKey:key];
            part = [NSString stringWithFormat:@"%@=\"%@\"", [key stringByAddingRFC3986PercentEscapesUsingEncoding:NSUTF8StringEncoding], [value stringByAddingRFC3986PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [parts addObject:part];
        }
    }
    
    [parts sortUsingSelector:@selector(compare:)];
    
    NSMutableString *oAuthArgumentMutableString = [NSMutableString stringWithString:@"OAuth "];
    [oAuthArgumentMutableString appendString:[parts componentsJoinedByString:@", "]];
    
    return oAuthArgumentMutableString;
}

+ (NSString *)generateHTTPBodyString:(NSDictionary *)httpBodyParameterDict
{
    NSMutableArray *parts = [NSMutableArray array];
    
    for (id key in httpBodyParameterDict)
    {
        @autoreleasepool {
            NSString *part;
            id value;
            value = [httpBodyParameterDict objectForKey:key];
            part = [NSString stringWithFormat:@"%@=%@", ([key isKindOfClass:[NSString class]] ? [key stringByAddingRFC3986PercentEscapesUsingEncoding:NSUTF8StringEncoding] : key), ([value isKindOfClass:[NSString class]] ? [value stringByAddingRFC3986PercentEscapesUsingEncoding:NSUTF8StringEncoding] : value)];
            [parts addObject:part];
        }
    }
    
    [parts sortUsingSelector:@selector(compare:)];
    
    return [parts componentsJoinedByString:@"&"];
}

+ (NSData *)generateHTTPBodyDataWithMultiPartDatas:(NSArray *)multiPartDatas multiPartNames:(NSArray *)multiPartNames multiPartTypes:(NSArray *)multiPartTypes boundary:(NSString *)boundary
{
    NSMutableData *body = [NSMutableData data];
    
    for (NSData *data in multiPartDatas) {
        @autoreleasepool {
            NSUInteger index = [multiPartDatas indexOfObject:data];
            
            NSString *name = [multiPartNames objectAtIndex:index];
            NSString *type = [multiPartTypes objectAtIndex:index];
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            if ([type isEqualToString:@"image/jpeg"])
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"./image.jpeg\"\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
            else
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
            if (type && !([type isEqualToString:@"text/plain"] || [type isEqualToString:@"multipart/form-data"]))
                [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n", type] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:data];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    // final boundary
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;
}

@end
