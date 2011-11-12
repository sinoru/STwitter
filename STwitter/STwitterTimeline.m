 //
//  STwitterTimeline.m
//  TweetBlast
//
//  Created by Sinoru on 11. 4. 4..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "STwitterTimeline.h"

#import "STwitterOAuthTool.h"
#import "NSString (RFC3875PercentEscapes).h"
#import "SBJson.h"


@implementation STwitterTimeline

- (id)getHomeTimelineWithAccount:(ACAccount *)account sinceID:(NSNumber *)sinceID maxID:(NSNumber *)maxID count:(NSNumber *)count trimUser:(BOOL)trimUser includeEntities:(BOOL)includeEntities error:(NSError **)error {
    // Declare Variables
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/home_timeline.json"];
    
    // Make Parameter Dictionary
    if (sinceID) {
        [parameterDict setObject:[sinceID stringValue] forKey:[NSString stringWithString:@"since_id"]];
    }
    
    if (maxID) {
        [parameterDict setObject:[maxID stringValue] forKey:[NSString stringWithString:@"max_id"]];
    }
    
    if (count) {
        [parameterDict setObject:[count stringValue] forKey:[NSString stringWithString:@"count"]];
    }
    
    if (trimUser) {
        [parameterDict setObject:[NSString stringWithString:@"true"] forKey:[NSString stringWithString:@"trim_user"]];
    }
    else {
        [parameterDict setObject:[NSString stringWithString:@"false"] forKey:[NSString stringWithString:@"trim_user"]];
    }
    
    if (includeEntities) {
        [parameterDict setObject:[NSString stringWithString:@"true"] forKey:[NSString stringWithString:@"include_entities"]];
    }
    else {
        [parameterDict setObject:[NSString stringWithString:@"false"] forKey:[NSString stringWithString:@"include_entities"]];
    }
    
    
    // Create Request
    TWRequest *request = [[TWRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:TWRequestMethodGET];
    request.account = account;
    
    // Get Response
    // TODO: Handling Error
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

- (id)getHomeTimelineWithOAuthConsumerKey:(NSString *)oAuthConsumerKey oAuthConsumerSecret:(NSString *)oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret sinceID:(NSNumber *)sinceID maxID:(NSNumber *)maxID count:(NSNumber *)count trimUser:(BOOL)trimUser includeEntities:(BOOL)includeEntities error:(NSError **)error {
    // Declare Variables
    NSString *oAuthNonce;
    NSString *oAuthTimestamp;
    NSString *oAuthArgumentString;
    NSMutableDictionary *httpBodyParameterDict;
    NSString *httpBodyParameterString = nil;
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/home_timeline.json"];
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
    
    if (sinceID) {
        [httpBodyParameterDict setObject:[[sinceID stringValue] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"since_id"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (maxID) {
        [httpBodyParameterDict setObject:[[maxID stringValue] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"max_id"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (count) {
        [httpBodyParameterDict setObject:[[count stringValue] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"count"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (trimUser) {
        [httpBodyParameterDict setObject:[[NSString stringWithString:@"true"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"trim_user"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    else {
        [httpBodyParameterDict setObject:[[NSString stringWithString:@"false"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"trim_user"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (includeEntities) {
        [httpBodyParameterDict setObject:[[NSString stringWithString:@"true"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"include_entities"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    else {
        [httpBodyParameterDict setObject:[[NSString stringWithString:@"false"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"include_entities"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
    
    // Set HTTP Method to POST
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

- (id)getMentionsWithAccount:(ACAccount *)account sinceID:(NSNumber *)sinceID maxID:(NSNumber *)maxID count:(NSNumber *)count trimUser:(BOOL)trimUser includeRetweets:(BOOL)includeRetweets includeEntities:(BOOL)includeEntities error:(NSError **)error
{
    // Declare Variables
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/mentions.json"];
    
    // Make Parameter Dictionary
    if (sinceID) {
        [parameterDict setObject:[sinceID stringValue] forKey:[NSString stringWithString:@"since_id"]];
    }
    
    if (maxID) {
        [parameterDict setObject:[maxID stringValue] forKey:[NSString stringWithString:@"max_id"]];
    }
    
    if (count) {
        [parameterDict setObject:[count stringValue] forKey:[NSString stringWithString:@"count"]];
    }
    
    if (trimUser) {
        [parameterDict setObject:[NSString stringWithString:@"true"] forKey:[NSString stringWithString:@"trim_user"]];
    }
    else {
        [parameterDict setObject:[NSString stringWithString:@"false"] forKey:[NSString stringWithString:@"trim_user"]];
    }
    
    if (includeRetweets) {
        [parameterDict setObject:[NSString stringWithString:@"true"] forKey:[NSString stringWithString:@"include_rts"]];
    }
    else {
        [parameterDict setObject:[NSString stringWithString:@"false"] forKey:[NSString stringWithString:@"include_rts"]];
    }
    
    if (includeEntities) {
        [parameterDict setObject:[NSString stringWithString:@"true"] forKey:[NSString stringWithString:@"include_entities"]];
    }
    else {
        [parameterDict setObject:[NSString stringWithString:@"false"] forKey:[NSString stringWithString:@"include_entities"]];
    }
    
    // Create Request
    TWRequest *request = [[TWRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:TWRequestMethodGET];
    request.account = account;
    
    // Get Response
    // TODO: Handling Error
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

- (id)getMentionsWithOAuthConsumerKey:(NSString *)oAuthConsumerKey oAuthConsumerSecret:(NSString *)oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret sinceID:(NSNumber *)sinceID maxID:(NSNumber *)maxID count:(NSNumber *)count trimUser:(BOOL)trimUser includeRetweets:(BOOL)includeRetweets includeEntities:(BOOL)includeEntities error:(NSError **)error {
    // Declare Variables
    NSString *oAuthNonce;
    NSString *oAuthTimestamp;
    NSString *oAuthArgumentString;
    NSMutableDictionary *httpBodyParameterDict;
    NSString *httpBodyParameterString = nil;
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/mentions.json"];
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
    
    if (sinceID) {
        [httpBodyParameterDict setObject:[[sinceID stringValue] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"since_id"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (maxID) {
        [httpBodyParameterDict setObject:[[maxID stringValue] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"max_id"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (count) {
        [httpBodyParameterDict setObject:[[count stringValue] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"count"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (trimUser) {
        [httpBodyParameterDict setObject:[[NSString stringWithString:@"true"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"trim_user"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    else {
        [httpBodyParameterDict setObject:[[NSString stringWithString:@"false"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"trim_user"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (includeRetweets) {
        [httpBodyParameterDict setObject:[[NSString stringWithString:@"true"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"include_rts"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    else {
        [httpBodyParameterDict setObject:[[NSString stringWithString:@"false"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"include_rts"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (includeEntities) {
        [httpBodyParameterDict setObject:[[NSString stringWithString:@"true"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"include_entities"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    else {
        [httpBodyParameterDict setObject:[[NSString stringWithString:@"false"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[NSString stringWithString:@"include_entities"] stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
    
    // Set HTTP Method to POST
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
