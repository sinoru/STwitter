//
//  STwitterFavorites.m
//  STwitter
//
//  Created by Sinoru on 11. 9. 9..
//  Copyright (c) 2011년 Sinoru. All rights reserved.
//

#import "STwitterFavorites.h"

#import "STwitter.h"
#import "SBJson/SBJson.h"

@implementation STwitterFavorites

+ (id)favoriteTweet:(NSNumber *)tweetID account:(ACAccount *)account includeEntities:(BOOL)includeEntities error:(NSError **)error
{
    // Declare Variables
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/favorites/create/%@.json", tweetID]];
    
    if (includeEntities) {
        [parameterDict setObject:@"true" forKey:@"include_entities"];
    }
    
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:STwitterRequestMethodPOST];
    request.account = account;
    
    // Get Response
    NSError *connectionError = nil;
    NSHTTPURLResponse *response = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:[request signedURLRequest] returningResponse:&response error:&connectionError];
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
            if ([parsedObject respondsToSelector:@selector(objectForKey:)]) {
                if ([parsedObject respondsToSelector:@selector(objectForKey:)]) {
                    id errorObject = [parsedObject objectForKey:@"error"];
                    
                    if (!errorObject) {
                        errorObject = [parsedObject objectForKey:@"errors"];
                        
                        if (!errorObject)
                            return parsedObject;
                    }
                    
                    NSInteger errorCode;
                    NSString *errorDescription;
                    
                    if ([errorObject isKindOfClass:[NSString class]]) {
                        errorDescription = errorObject;
                        errorCode = [response statusCode];
                    }
                    else if ([errorObject isKindOfClass:[NSDictionary class]]) {
                        errorDescription = [errorObject objectForKey:@"message"];
                        errorCode = [[errorObject objectForKey:@"code"] integerValue];
                    }
                    
                    *error = [[NSError alloc] initWithDomain:STwitterErrorDomain code:errorCode userInfo:[NSDictionary dictionaryWithObject:errorDescription forKey:NSLocalizedDescriptionKey]];
                }
                else {
                    return parsedObject;
                }
            }
            else {
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

+ (id)favoriteTweet:(NSNumber *)tweetID OAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret OAuthAccessToken:(NSString *)OAuthAccessToken OAuthAccessTokenSecret:(NSString *)OAuthAccessTokenSecret includeEntities:(BOOL)includeEntities error:(NSError **)error
{
    // Declare Variables
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/favorites/create/%@.json", tweetID]];
    
    if (includeEntities) {
        [parameterDict setObject:@"true" forKey:@"include_entities"];
    }
    
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:STwitterRequestMethodPOST];
    request.OAuthToken = [[NSDictionary alloc] initWithObjectsAndKeys:OAuthConsumerKey, kOAuthConsumerKey, OAuthConsumerSecret, kOAuthConsumerSecret, OAuthAccessToken, kOAuthToken, OAuthAccessTokenSecret, kOAuthTokenSecret, nil];
    
    // Get Response
    NSError *connectionError = nil;
    NSHTTPURLResponse *response = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:[request signedURLRequest] returningResponse:&response error:&connectionError];
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
            if ([parsedObject respondsToSelector:@selector(objectForKey:)]) {
                if ([parsedObject respondsToSelector:@selector(objectForKey:)]) {
                    id errorObject = [parsedObject objectForKey:@"error"];
                    
                    if (!errorObject) {
                        errorObject = [parsedObject objectForKey:@"errors"];
                        
                        if (!errorObject)
                            return parsedObject;
                    }
                    
                    NSInteger errorCode;
                    NSString *errorDescription;
                    
                    if ([errorObject isKindOfClass:[NSString class]]) {
                        errorDescription = errorObject;
                        errorCode = [response statusCode];
                    }
                    else if ([errorObject isKindOfClass:[NSDictionary class]]) {
                        errorDescription = [errorObject objectForKey:@"message"];
                        errorCode = [[errorObject objectForKey:@"code"] integerValue];
                    }
                    
                    *error = [[NSError alloc] initWithDomain:STwitterErrorDomain code:errorCode userInfo:[NSDictionary dictionaryWithObject:errorDescription forKey:NSLocalizedDescriptionKey]];
                }
                else {
                    return parsedObject;
                }
            }
            else {
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
