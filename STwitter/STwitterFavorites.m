//
//  STwitterFavorites.m
//  TweetBlast
//
//  Created by 재홍 강 on 11. 9. 9..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "STwitterFavorites.h"

#import "NSString (RFC3875PercentEscapes).h"
#import "SBJson.h"
#import "STwitterOAuthTool.h"

@implementation STwitterFavorites

- (id)favoriteTweet:(NSNumber *)retweetID account:(ACAccount *)account includeEntities:(BOOL)includeEntities error:(NSError **)error
{
    // Declare Variables
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/favorites/create/%@.json", retweetID]];
    
    if (includeEntities) {
        [parameterDict setObject:[NSString stringWithString:@"true"] forKey:[NSString stringWithString:@"include_entities"]];
    }
    
    TWRequest *request = [[TWRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:TWRequestMethodPOST];
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

- (id)favoriteTweet:(NSNumber *)retweetID oAuthConsumerKey:oAuthConsumerKey oAuthConsumerSecret:oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret includeEntities:(BOOL)includeEntities error:(NSError **)error
{
    // Declare Variables
    NSString *oAuthNonce;
    NSString *oAuthTimestamp;
    NSString *oAuthArgumentString;
    NSMutableDictionary *httpBodyParameterDict;
    NSData *httpBodyParameterData;
    NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/favorites/create/%@.json", retweetID]];
    
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
    
    if ([httpBodyParameterDict count]) {
        httpBodyParameterData = [[sTwitterOAuthTool generateHTTPBody:httpBodyParameterDict] dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    // Generate and Add OAuthTokenSignature
    NSMutableDictionary *oAuthSignatureDict = [[NSMutableDictionary alloc] initWithDictionary:oAuthArgumentDict];
    [oAuthSignatureDict addEntriesFromDictionary:httpBodyParameterDict];
    
    [oAuthArgumentDict setObject:[sTwitterOAuthTool generateOAuthSignature:oAuthSignatureDict httpMethod:@"POST" apiURL:apiURL oAuthConsumerSecret:oAuthConsumerSecret oAuthTokenSecret:oAuthAccessTokenSecret] forKey:@"oauth_signature"];
    
    // Generate HTTP Authorization Header String
    oAuthArgumentString = [sTwitterOAuthTool generateHTTPAuthorizationHeader:oAuthArgumentDict];
    
    // Create Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    
    // Set HTTP Method to POST
    [request setHTTPMethod:@"POST"];
    
    // Set HTTP Authorization Header to requestsParameter
    [request setValue:oAuthArgumentString forHTTPHeaderField:@"Authorization"];
    
    // Set HTTP Body
    [request setHTTPBody:httpBodyParameterData];
    
    // Get Response
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

@end
