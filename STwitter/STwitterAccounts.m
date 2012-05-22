//
//  STwitterAccounts.m
//  STwitter
//
//  Created by Sinoru on 11. 10. 15..
//  Copyright (c) 2011년 Sinoru. All rights reserved.
//

#import "STwitterAccounts.h"

#import "STwitter.h"
#import "SBJson/SBJson.h"

@implementation STwitterAccounts

+ (NSDictionary *)verifyCredentialsWithAccount:(ACAccount *)account includeEntities:(BOOL)includeEntities skipStatus:(BOOL)skipStatus error:(NSError **)error {
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/1/account/verify_credentials.json"];
    
    // Make Parameter Dictionary
    if (includeEntities) {
        [parameterDict setObject:@"true" forKey:@"include_entities"];
    }
    else {
        [parameterDict setObject:@"false" forKey:@"include_entities"];
    }
    if (skipStatus) {
        [parameterDict setObject:@"true" forKey:@"skip_status"];
    }
    else {
        [parameterDict setObject:@"false" forKey:@"skip_status"];
    }
    
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:STwitterRequestMethodGET];
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

+ (NSDictionary *)verifyCredentialsWithOAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret OAuthAccessToken:(NSString *)OAuthAccessToken OAuthAccessTokenSecret:(NSString *)OAuthAccessTokenSecret includeEntities:(BOOL)includeEntities skipStatus:(BOOL)skipStatus error:(NSError **)error {
    // Declare Variables
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/1/account/verify_credentials.json"];
    
    // Make Parameter Dictionary
    if (includeEntities) {
        [parameterDict setObject:@"true" forKey:@"include_entities"];
    }
    else {
        [parameterDict setObject:@"false" forKey:@"include_entities"];
    }
    if (skipStatus) {
        [parameterDict setObject:@"true" forKey:@"skip_status"];
    }
    else {
        [parameterDict setObject:@"false" forKey:@"skip_status"];
    }
    
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:STwitterRequestMethodGET];
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
