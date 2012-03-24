//
//  STwitterOAuth.m
//  TweetBlast
//
//  Created by Sinoru on 11. 3. 29..
//  Copyright 2011 Sinoru. All rights reserved.
//

#import "STwitterOAuth.h"

#import "STwitterOAuthTool.h"
#import "NSString (RFC3875PercentEscapes).h"


@implementation STwitterOAuth

+ (NSDictionary *)requestRequestTokenWithOAuthConsumerKey:oAuthConsumerKey oAuthConsumerSecret:oAuthConsumerSecret
{
    // Declare Variables
    NSString *oAuthNonce;
    NSString *oAuthTimestamp;
    NSString *oAuthArgumentString;
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
    
    // Generate UUID for OAuth Nonce
    oAuthNonce = [STwitterOAuthTool generateUUID];
    
    // Generate Time Stamp
    oAuthTimestamp = [NSString stringWithFormat:@"%i" , [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] intValue]];
    
    NSMutableDictionary *oAuthArgumentDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"oob", @"oauth_callback", oAuthConsumerKey, @"oauth_consumer_key", oAuthNonce, @"oauth_nonce", @"HMAC-SHA1", @"oauth_signature_method", oAuthTimestamp, @"oauth_timestamp", @"1.0", @"oauth_version", nil];
    
    // Generate and Add OAuthTokenSignature
    [oAuthArgumentDict setObject:[STwitterOAuthTool generateOAuthSignature:oAuthArgumentDict httpMethod:@"POST" apiURL:apiURL oAuthConsumerSecret:oAuthConsumerSecret oAuthTokenSecret:nil] forKey:@"oauth_signature"];
    
    // Generate HTTP Authorization Header String
    oAuthArgumentString = [STwitterOAuthTool generateHTTPAuthorizationHeader:oAuthArgumentDict];
    
    // Create Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    
    // Set HTTP Method to POST
    [request setHTTPMethod:@"POST"];
    
    // Set HTTP Authorization Header to requestsParameter
    [request setValue:oAuthArgumentString forHTTPHeaderField:@"Authorization"];
    
    // Get Token
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSMutableDictionary *returnDict = nil;
    if (returnData) {
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        if (returnString) {
            NSArray *returnArray = [returnString componentsSeparatedByString:@"&"];
            if (returnArray) {
                returnDict = [[NSMutableDictionary alloc] init];
                
                for(id argument in returnArray)
                {
                    @autoreleasepool {
                        NSArray *argumentKeyAndObject = [argument componentsSeparatedByString:@"="];
                        [returnDict setObject:[argumentKeyAndObject objectAtIndex:1] forKey:[argumentKeyAndObject objectAtIndex:0]];
                    }
                }
                
            }
        }
    }
    
    return returnDict;
}

+ (NSURLRequest *)authorizeURLRequestWithRequestToken:(NSString *)token
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", token]] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:5.0f];
    
    // Set HTTP Method to GET
    [request setHTTPMethod:@"GET"];
    
    return request;
}

+ (NSDictionary *)exchangeRequestTokenToAccessTokenWithOAuthConsumerKey:oAuthConsumerKey oAuthConsumerSecret:oAuthConsumerSecret oAuthRequestToken:(NSString *)oAuthRequestToken oAuthRequestTokenSecret:(NSString *)oAuthRequestTokenSecret oAuthVerifier:oAuthVerifier
{
    // Declare Variables
    NSString *oAuthNonce;
    NSString *oAuthTimestamp;
    NSString *oAuthArgumentString;
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    
    // Generate UUID for OAuth Nonce
    oAuthNonce = [STwitterOAuthTool generateUUID];
    
    // Generate Time Stamp
    oAuthTimestamp = [NSString stringWithFormat:@"%i" , [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] intValue]];
    
    NSMutableDictionary *oAuthArgumentDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:oAuthConsumerKey, @"oauth_consumer_key", oAuthNonce, @"oauth_nonce", @"HMAC-SHA1", @"oauth_signature_method", oAuthRequestToken, @"oauth_token", oAuthTimestamp, @"oauth_timestamp", @"1.0", @"oauth_version", nil];
    
    // Generate and Add OAuthTokenSignature
    [oAuthArgumentDict setObject:[STwitterOAuthTool generateOAuthSignature:oAuthArgumentDict httpMethod:@"POST" apiURL:apiURL oAuthConsumerSecret:oAuthConsumerSecret oAuthTokenSecret:oAuthRequestTokenSecret] forKey:@"oauth_signature"];
    
    // Generate HTTP Authorization Header String
    oAuthArgumentString = [STwitterOAuthTool generateHTTPAuthorizationHeader:oAuthArgumentDict];
    
    // Create Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    
    // Set HTTP Method to POST
    [request setHTTPMethod:@"POST"];
    
    // Set HTTP Authorization Header to requestsParameter
    [request setValue:oAuthArgumentString forHTTPHeaderField:@"Authorization"];
    
    // Get Token
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSArray *returnArray = [returnString componentsSeparatedByString:@"&"];
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] init];
    
    for(id argument in returnArray)
    {
        @autoreleasepool {
            NSArray *argumentKeyAndObject = [argument componentsSeparatedByString:@"="];
            [returnDict setObject:[argumentKeyAndObject objectAtIndex:1] forKey:[argumentKeyAndObject objectAtIndex:0]];
        }
    }
    
    return returnDict;
}

@end
