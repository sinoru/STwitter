//
//  STwitterAccounts.m
//  TweetBlast
//
//  Created by 재홍 강 on 11. 10. 15..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "STwitterAccounts.h"

#import "STwitterOAuthTool.h"
#import "NSString (RFC3875PercentEscapes).h"
#import "SBJson.h"

@implementation STwitterAccounts

- (NSDictionary *)verifyCredentialsWithAccount:(ACAccount *)account includeEntities:(BOOL)includeEntities skipStatus:(BOOL)skipStatus error:(NSError **)error {
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/1/account/verify_credentials.json"];
    
    // Make Parameter Dictionary
    if (includeEntities) {
        [parameterDict setObject:[NSString stringWithString:@"true"] forKey:[NSString stringWithString:@"include_entities"]];
    }
    else {
        [parameterDict setObject:[NSString stringWithString:@"false"] forKey:[NSString stringWithString:@"include_entities"]];
    }
    if (skipStatus) {
        [parameterDict setObject:[NSString stringWithString:@"true"] forKey:[NSString stringWithString:@"skip_status"]];
    }
    else {
        [parameterDict setObject:[NSString stringWithString:@"false"] forKey:[NSString stringWithString:@"skip_status"]];
    }
    
    TWRequest *request = [[TWRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:TWRequestMethodGET];
    request.account = account;
    
    // Get Response
    NSError *connectionError = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:[request signedURLRequest] returningResponse:nil error:&connectionError];
    if (connectionError) {
        if (error != nil) {
            *error = [connectionError copy];
        }
    }
    else if (returnData) {
        id parsedObject;
        NSError *parsingError = nil;
        
        
        if ([NSJSONSerialization class]) {
            parsedObject = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:&parsingError];
        }
        else {
            NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            
            if (returnString) {
                SBJsonParser *sbJsonParser = [[SBJsonParser alloc] init];
                parsedObject = [sbJsonParser objectWithString:returnString error:&parsingError];
            }
        }
        
        if (!parsingError) {
            return parsedObject;
        }
        else {
            if (error != nil) {
                *error = [parsingError copy];
            }
        }
    }
    
    return nil;
}

- (NSDictionary *)verifyCredentialsWithoAuthConsumerKey:oAuthConsumerKey oAuthConsumerSecret:oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret includeEntities:(BOOL)includeEntities skipStatus:(BOOL)skipStatus error:(NSError **)error {
    // Declare Variables
    NSString *oAuthNonce;
    NSString *oAuthTimestamp;
    NSString *oAuthArgumentString;
    NSMutableDictionary *httpBodyParameterDict;
    NSString *httpBodyParameterString = nil;
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/1/account/verify_credentials.json"];
    NSURL *requestURL;
    
    // Generate UUID for OAuth Nonce
    STwitterOAuthTool *sTwitterOAuthTool = [[STwitterOAuthTool alloc] init];
    oAuthNonce = [sTwitterOAuthTool generateUUID];
    
    // Generate Time Stamp
    oAuthTimestamp = [NSString stringWithFormat:@"%i" , [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] intValue]];
    
    // Make OAuth Arguemnt Dictionary
    NSMutableDictionary *oAuthArgumentDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:oAuthConsumerKey, @"oauth_consumer_key", oAuthNonce, @"oauth_nonce", @"HMAC-SHA1", @"oauth_signature_method", oAuthAccessToken, @"oauth_token", oAuthTimestamp, @"oauth_timestamp", @"1.0", @"oauth_version", nil];
    
    // Make HTTP Body Dictionary and Data
    
    httpBodyParameterDict = [NSMutableDictionary dictionary];
    
    if (includeEntities) {
        [httpBodyParameterDict setObject:[[NSString stringWithString:@"true"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"include_entities"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    else {
        [httpBodyParameterDict setObject:[[NSString stringWithString:@"false"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"include_entities"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (skipStatus) {
        [httpBodyParameterDict setObject:[[NSString stringWithString:@"true"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"skip_status"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    else {
        [httpBodyParameterDict setObject:[[NSString stringWithString:@"false"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"skip_status"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([httpBodyParameterDict count]) {
        httpBodyParameterString = [sTwitterOAuthTool generateHTTPBody:httpBodyParameterDict];
    }
    
    
    // Generate and Add OAuthTokenSignature
    NSMutableDictionary *oAuthSignatureDict = [[NSMutableDictionary alloc] initWithDictionary:oAuthArgumentDict];
    [oAuthSignatureDict addEntriesFromDictionary:httpBodyParameterDict];
    
    [oAuthArgumentDict setObject:[sTwitterOAuthTool generateOAuthSignature:oAuthSignatureDict httpMethod:@"GET" apiURL:apiURL oAuthConsumerSecret:oAuthConsumerSecret oAuthTokenSecret:oAuthAccessTokenSecret] forKey:@"oauth_signature"];
    
    // Generate HTTP Authorization Header String
    oAuthArgumentString = [sTwitterOAuthTool generateHTTPAuthorizationHeader:oAuthArgumentDict];
    
    
    // Create Request
    if (httpBodyParameterString) {
        requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [apiURL absoluteString], httpBodyParameterString]];
    }
    else {
        requestURL = apiURL;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    
    // Set HTTP Method to GET
    [request setHTTPMethod:@"GET"];
    
    // Set HTTP Authorization Header to requestsParameter
    [request setValue:oAuthArgumentString forHTTPHeaderField:@"Authorization"];
    
    // Get Response
    // TODO: Handling Error
    NSError *connectionError = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&connectionError];
    if (connectionError) {
        if (error != nil) {
            *error = [connectionError copy];
        }
    }
    else if (returnData) {
        id parsedObject;
        NSError *parsingError = nil;
        
        
        if ([NSJSONSerialization class]) {
            parsedObject = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:&parsingError];
        }
        else {
            NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            
            if (returnString) {
                SBJsonParser *sbJsonParser = [[SBJsonParser alloc] init];
                parsedObject = [sbJsonParser objectWithString:returnString error:&parsingError];
            }
        }
        
        if (!parsingError) {
            if (!([parsedObject isKindOfClass:[NSDictionary class]] && [[parsedObject objectForKey:@"error"] isKindOfClass:[NSString class]])) {
                return parsedObject;
            }
        }
        else {
            if (error != nil) {
                *error = [parsingError copy];
            }
        }
    }
    
    return nil;
}

@end
