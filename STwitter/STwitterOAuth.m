//
//  STwitterOAuth.m
//  STwitter
//
//  Created by Sinoru on 11. 3. 29..
//  Copyright 2011 Sinoru. All rights reserved.
//

#import "STwitterOAuth.h"

#import "STwitterOAuthTool.h"

@implementation STwitterOAuth

+ (NSDictionary *)getRequestTokenWithOAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret
{
    // Declare Variables
    NSString *OAuthNonce;
    NSString *OAuthTimestamp;
    NSString *OAuthArgumentString;
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
    
    // Generate UUID for OAuth Nonce
    OAuthNonce = [STwitterOAuthTool generateUUID];
    
    // Generate Time Stamp
    OAuthTimestamp = [NSString stringWithFormat:@"%i" , [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] intValue]];
    
    NSMutableDictionary *oAuthArgumentDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"oob", @"oauth_callback", OAuthConsumerKey, @"oauth_consumer_key", OAuthNonce, @"oauth_nonce", @"HMAC-SHA1", @"oauth_signature_method", OAuthTimestamp, @"oauth_timestamp", @"1.0", @"oauth_version", nil];
    
    // Generate and Add OAuthTokenSignature
    [oAuthArgumentDict setObject:[STwitterOAuthTool generateOAuthSignature:oAuthArgumentDict httpMethod:@"POST" apiURL:apiURL oAuthConsumerSecret:OAuthConsumerSecret oAuthTokenSecret:nil] forKey:@"oauth_signature"];
    
    // Generate HTTP Authorization Header String
    OAuthArgumentString = [STwitterOAuthTool generateHTTPAuthorizationHeader:oAuthArgumentDict];
    
    // Create Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    
    // Set HTTP Method to POST
    [request setHTTPMethod:@"POST"];
    
    // Set HTTP Authorization Header to requestsParameter
    [request setValue:OAuthArgumentString forHTTPHeaderField:@"Authorization"];
    
    // Get Token
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSMutableDictionary *parsedDict = nil;
    if (receivedData) {
        NSString *returnString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        if (returnString) {
            NSArray *parsedArray = [returnString componentsSeparatedByString:@"&"];
            if (parsedArray) {
                parsedDict = [[NSMutableDictionary alloc] init];
                
                for(id argument in parsedArray)
                {
                    @autoreleasepool {
                        NSArray *argumentKeyAndObject = [argument componentsSeparatedByString:@"="];
                        [parsedDict setObject:[argumentKeyAndObject objectAtIndex:1] forKey:[argumentKeyAndObject objectAtIndex:0]];
                    }
                }
                
            }
        }
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:[parsedDict objectForKey:@"oauth_token"], @"OAuthRequestToken", [parsedDict objectForKey:@"oauth_token_secret"], @"OAuthRequestTokenSecret", nil];
}

+ (NSURLRequest *)getUserAuthorizeURLRequestWithRequestToken:(NSString *)token
{
    return [self getUserAuthorizeURLRequestWithRequestToken:token forceLogin:NO screenName:nil];
}

+ (NSURLRequest *)getUserAuthorizeURLRequestWithRequestToken:(NSString *)token forceLogin:(BOOL)forceLogin screenName:(NSString *)screenName
{
    NSURL *apiURL;
    if (screenName)
        apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@&force_login=%@&screen_name=%@", token, forceLogin ? @"true" : @"false", screenName]];
    else
        apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@&force_login=%@", token, forceLogin ? @"true" : @"false"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:apiURL cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:5.0f];
    
    // Set HTTP Method to GET
    [request setHTTPMethod:@"GET"];
    
    return request;
}


+ (NSDictionary *)exchangeRequestTokenForAccessTokenWithOAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret OAuthRequestToken:(NSString *)OAuthRequestToken OAuthRequestTokenSecret:(NSString *)OAuthRequestTokenSecret OAuthVerifier:OAuthVerifier
{
    // Declare Variables
    NSString *OAuthNonce;
    NSString *OAuthTimestamp;
    NSString *OAuthArgumentString;
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    
    // Generate UUID for OAuth Nonce
    OAuthNonce = [STwitterOAuthTool generateUUID];
    
    // Generate Time Stamp
    OAuthTimestamp = [NSString stringWithFormat:@"%i" , [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] intValue]];
    
    NSMutableDictionary *OAuthArgumentDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:OAuthConsumerKey, @"oauth_consumer_key", OAuthNonce, @"oauth_nonce", @"HMAC-SHA1", @"oauth_signature_method", OAuthRequestToken, @"oauth_token", OAuthTimestamp, @"oauth_timestamp", @"1.0", @"oauth_version", OAuthVerifier, @"oauth_verifier", nil];
    
    // Generate and Add OAuthTokenSignature
    [OAuthArgumentDict setObject:[STwitterOAuthTool generateOAuthSignature:OAuthArgumentDict httpMethod:@"POST" apiURL:apiURL oAuthConsumerSecret:OAuthConsumerSecret oAuthTokenSecret:OAuthRequestTokenSecret] forKey:@"oauth_signature"];
    
    // Generate HTTP Authorization Header String
    OAuthArgumentString = [STwitterOAuthTool generateHTTPAuthorizationHeader:OAuthArgumentDict];
    
    // Create Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    
    // Set HTTP Method to POST
    [request setHTTPMethod:@"POST"];
    
    // Set HTTP Authorization Header to requestsParameter
    [request setValue:OAuthArgumentString forHTTPHeaderField:@"Authorization"];
    
    // Get Token
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSArray *parsedArray = [returnString componentsSeparatedByString:@"&"];
    NSMutableDictionary *parsedDict = [[NSMutableDictionary alloc] init];
    
    for(id argument in parsedArray)
    {
        @autoreleasepool {
            NSArray *argumentKeyAndObject = [argument componentsSeparatedByString:@"="];
            [parsedDict setObject:[argumentKeyAndObject objectAtIndex:1] forKey:[argumentKeyAndObject objectAtIndex:0]];
        }
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:[parsedDict objectForKey:@"oauth_token"], @"OAuthAccessToken", [parsedDict objectForKey:@"oauth_token_secret"], @"OAuthAccessTokenSecret", nil];
}

+ (NSDictionary *)exchangeRequestTokenForAccessTokenWithOAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret OAuthRequestToken:(NSString *)OAuthRequestToken OAuthRequestTokenSecret:(NSString *)OAuthRequestTokenSecret xAuthUsername:(NSString *)xAuthUsername xAuthPassword:(NSString *)xAuthPassword
{
    // Declare Variables
    NSString *OAuthNonce;
    NSString *OAuthTimestamp;
    NSString *OAuthArgumentString;
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    
    // Generate UUID for OAuth Nonce
    OAuthNonce = [STwitterOAuthTool generateUUID];
    
    // Generate Time Stamp
    OAuthTimestamp = [NSString stringWithFormat:@"%i" , [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] intValue]];
    
    NSMutableDictionary *OAuthArgumentDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:OAuthConsumerKey, @"oauth_consumer_key", OAuthNonce, @"oauth_nonce", @"HMAC-SHA1", @"oauth_signature_method", OAuthRequestToken, @"oauth_token", OAuthTimestamp, @"oauth_timestamp", @"1.0", @"oauth_version", xAuthPassword, @"x_auth_password", xAuthUsername, @"x_auth_username", @"client_auth", @"x_auth_mode", nil];
    
    // Generate and Add OAuthTokenSignature
    [OAuthArgumentDict setObject:[STwitterOAuthTool generateOAuthSignature:OAuthArgumentDict httpMethod:@"POST" apiURL:apiURL oAuthConsumerSecret:OAuthConsumerSecret oAuthTokenSecret:OAuthRequestTokenSecret] forKey:@"oauth_signature"];
    
    // Generate HTTP Authorization Header String
    OAuthArgumentString = [STwitterOAuthTool generateHTTPAuthorizationHeader:OAuthArgumentDict];
    
    // Create Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    
    // Set HTTP Method to POST
    [request setHTTPMethod:@"POST"];
    
    // Set HTTP Authorization Header to requestsParameter
    [request setValue:OAuthArgumentString forHTTPHeaderField:@"Authorization"];
    
    // Get Token
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSArray *parsedArray = [returnString componentsSeparatedByString:@"&"];
    NSMutableDictionary *parsedDict = [[NSMutableDictionary alloc] init];
    
    for(id argument in parsedArray)
    {
        @autoreleasepool {
            NSArray *argumentKeyAndObject = [argument componentsSeparatedByString:@"="];
            [parsedDict setObject:[argumentKeyAndObject objectAtIndex:1] forKey:[argumentKeyAndObject objectAtIndex:0]];
        }
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:[parsedDict objectForKey:@"oauth_token"], @"OAuthAccessToken", [parsedDict objectForKey:@"oauth_token_secret"], @"OAuthAccessTokenSecret", nil];
}

@end
