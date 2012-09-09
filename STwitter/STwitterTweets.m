//
//  STwitterTweets.m
//  STwitter
//
//  Created by Sinoru on 11. 3. 31..
//  Copyright 2011 Sinoru. All rights reserved.
//

#import "STwitterTweets.h"

#import "SBJson/SBJson.h"
#import "STwitter.h"

@implementation STwitterTweets

+ (id)statusUpdate:(NSString *)status account:(ACAccount *)account inReplyToStatusID:(NSNumber *)inReplyToStatusID latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude placeID:(NSNumber *)placeID displayCoordinates:(BOOL)displayCoordinates error:(out NSError **)error
{
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/update.json"];
    
    // Make Parameter Dictionary
    if (status) {
        [parameterDict setObject:status forKey:@"status"];
    }
    if (inReplyToStatusID) {
        [parameterDict setObject:[inReplyToStatusID stringValue] forKey:@"in_reply_to_status_id"];
    }
    if (latitude && longitude) {
        [parameterDict setObject:[latitude stringValue] forKey:@"lat"];
        [parameterDict setObject:[longitude stringValue] forKey:@"long"];
    }
    if (placeID) {
        [parameterDict setObject:[placeID stringValue] forKey:@"place_id"];
        [parameterDict setObject:[NSNumber numberWithBool:displayCoordinates] forKey:@"display_coordinates"];
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
                
                if (error) {
                    *error = [[NSError alloc] initWithDomain:STwitterErrorDomain code:errorCode userInfo:[NSDictionary dictionaryWithObject:errorDescription forKey:NSLocalizedDescriptionKey]];
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

+ (id)statusUpdate:(NSString *)status account:(ACAccount *)account inReplyToStatusID:(NSNumber *)inReplyToStatusID error:(out NSError **)error
{
    return [self statusUpdate:status account:account inReplyToStatusID:inReplyToStatusID latitude:nil longitude:nil placeID:nil displayCoordinates:YES error:error];
}

+ (id)retweetTweet:(NSNumber *)tweetID account:(ACAccount *)account includeEntities:(BOOL)includeEntities trimUser:(BOOL)trimUser error:(out NSError **)error
{
    // Declare Variables
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/statuses/retweet/%@.json", tweetID]];
    
    if (includeEntities) {
        [parameterDict setObject:@"true" forKey:@"include_entities"];
    }
    if (trimUser) {
        [parameterDict setObject:@"true" forKey:@"trim_user"];
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
                
                if (error) {
                    *error = [[NSError alloc] initWithDomain:STwitterErrorDomain code:errorCode userInfo:[NSDictionary dictionaryWithObject:errorDescription forKey:NSLocalizedDescriptionKey]];
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

+ (id)showStatus:(NSNumber *)tweetID account:(ACAccount *)account includeEntities:(BOOL)includeEntities includeMyRetweet:(BOOL)includeMyRetweet trimUser:(BOOL)trimUser error:(out NSError *__autoreleasing *)error
{
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/show.json"];
    
    // Make Parameter Dictionary
    if (tweetID) {
        [parameterDict setObject:[tweetID stringValue] forKey:@"id"];
    }
    
    [parameterDict setObject:includeEntities ? @"true" : @"false" forKey:@"include_entities"];
    [parameterDict setObject:includeMyRetweet ? @"true" : @"false" forKey:@"include_my_retweet"];
    [parameterDict setObject:trimUser ? @"true" : @"false" forKey:@"trim_user"];
    
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:STwitterRequestMethodGET];
    if (account)
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
                
                if (error) {
                    *error = [[NSError alloc] initWithDomain:STwitterErrorDomain code:errorCode userInfo:[NSDictionary dictionaryWithObject:errorDescription forKey:NSLocalizedDescriptionKey]];
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

+ (id)statusUpdate:(NSString *)status OAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret OAuthAccessToken:(NSString *)OAuthAccessToken OAuthAccessTokenSecret:(NSString *)OAuthAccessTokenSecret inReplyToStatusID:(NSNumber *)inReplyToStatusID latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude placeID:(NSNumber *)placeID displayCoordinates:(BOOL)displayCoordinates error:(out NSError **)error
{
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/update.json"];
    
    // Make Parameter Dictionary
    if (status) {
        [parameterDict setObject:status forKey:@"status"];
    }
    if (inReplyToStatusID) {
        [parameterDict setObject:[inReplyToStatusID stringValue] forKey:@"in_reply_to_status_id"];
    }
    if (latitude && longitude) {
        [parameterDict setObject:[latitude stringValue] forKey:@"lat"];
        [parameterDict setObject:[longitude stringValue] forKey:@"long"];
    }
    if (placeID) {
        [parameterDict setObject:[placeID stringValue] forKey:@"place_id"];
        [parameterDict setObject:[NSNumber numberWithBool:displayCoordinates] forKey:@"display_coordinates"];
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
                
                if (error) {
                    *error = [[NSError alloc] initWithDomain:STwitterErrorDomain code:errorCode userInfo:[NSDictionary dictionaryWithObject:errorDescription forKey:NSLocalizedDescriptionKey]];
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

+ (id)statusUpdate:(NSString *)status OAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret OAuthAccessToken:(NSString *)OAuthAccessToken OAuthAccessTokenSecret:(NSString *)OAuthAccessTokenSecret inReplyToStatusID:(NSNumber *)inReplyToStatusID error:(out NSError **)error
{
    return [self statusUpdate:status OAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret OAuthAccessToken:OAuthAccessToken OAuthAccessTokenSecret:OAuthAccessTokenSecret inReplyToStatusID:inReplyToStatusID latitude:nil longitude:nil placeID:nil displayCoordinates:YES error:nil];
}

+ (id)retweetTweet:(NSNumber *)tweetID OAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret OAuthAccessToken:(NSString *)OAuthAccessToken OAuthAccessTokenSecret:(NSString *)OAuthAccessTokenSecret includeEntities:(BOOL)includeEntities trimUser:(BOOL)trimUser error:(out NSError **)error
{
    // Declare Variables
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/statuses/retweet/%@.json", tweetID]];
    
    if (includeEntities) {
        [parameterDict setObject:@"true" forKey:@"include_entities"];
    }
    if (trimUser) {
        [parameterDict setObject:@"true" forKey:@"trim_user"];
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
                
                if (error) {
                    *error = [[NSError alloc] initWithDomain:STwitterErrorDomain code:errorCode userInfo:[NSDictionary dictionaryWithObject:errorDescription forKey:NSLocalizedDescriptionKey]];
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

+ (id)showStatus:(NSNumber *)tweetID OAuthConsumerKey:(id)OAuthConsumerKey OAuthConsumerSecret:(id)OAuthConsumerSecret OAuthAccessToken:(NSString *)OAuthAccessToken OAuthAccessTokenSecret:(NSString *)OAuthAccessTokenSecret includeEntities:(BOOL)includeEntities includeMyRetweet:(BOOL)includeMyRetweet trimUser:(BOOL)trimUser error:(out NSError *__autoreleasing *)error
{
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/show.json"];
    
    // Make Parameter Dictionary
    if (tweetID) {
        [parameterDict setObject:[tweetID stringValue] forKey:@"id"];
    }
    
    [parameterDict setObject:includeEntities ? @"true" : @"false" forKey:@"include_entities"];
    [parameterDict setObject:includeMyRetweet ? @"true" : @"false" forKey:@"include_my_retweet"];
    [parameterDict setObject:trimUser ? @"true" : @"false" forKey:@"trim_user"];
    
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:STwitterRequestMethodGET];
    if (OAuthConsumerKey && OAuthConsumerSecret && OAuthAccessToken && OAuthAccessTokenSecret)
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
                
                if (error) {
                    *error = [[NSError alloc] initWithDomain:STwitterErrorDomain code:errorCode userInfo:[NSDictionary dictionaryWithObject:errorDescription forKey:NSLocalizedDescriptionKey]];
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
