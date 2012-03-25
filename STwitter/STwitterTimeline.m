//
//  STwitterTimeline.m
//  STwitter
//
//  Created by Sinoru on 11. 4. 4..
//  Copyright 2011 Sinoru. All rights reserved.
//

#import "STwitterTimeline.h"

#import "STwitterOAuthTool.h"
#import "STwitterRequest.h"
#import "NSString (RFC3875PercentEscapes).h"
#import "SBJson/SBJson.h"


@implementation STwitterTimeline

+ (id)getHomeTimelineWithAccount:(ACAccount *)account sinceID:(NSNumber *)sinceID maxID:(NSNumber *)maxID count:(NSNumber *)count trimUser:(BOOL)trimUser includeEntities:(BOOL)includeEntities error:(NSError **)error {
    // Declare Variables
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/home_timeline.json"];
    
    // Make Parameter Dictionary
    if (sinceID) {
        [parameterDict setObject:[sinceID stringValue] forKey:@"since_id"];
    }
    
    if (maxID) {
        [parameterDict setObject:[maxID stringValue] forKey:@"max_id"];
    }
    
    if (count) {
        [parameterDict setObject:[count stringValue] forKey:@"count"];
    }
    
    if (trimUser) {
        [parameterDict setObject:@"true" forKey:@"trim_user"];
    }
    else {
        [parameterDict setObject:@"false" forKey:@"trim_user"];
    }
    
    if (includeEntities) {
        [parameterDict setObject:@"true" forKey:@"include_entities"];
    }
    else {
        [parameterDict setObject:@"false" forKey:@"include_entities"];
    }
    
    
    // Create Request
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:STwitterRequestMethodGET];
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

+ (id)getHomeTimelineWithOAuthConsumerKey:(NSString *)oAuthConsumerKey oAuthConsumerSecret:(NSString *)oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret sinceID:(NSNumber *)sinceID maxID:(NSNumber *)maxID count:(NSNumber *)count trimUser:(BOOL)trimUser includeEntities:(BOOL)includeEntities error:(NSError **)error {
    // Declare Variables
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/home_timeline.json"];
    
    // Make Parameter Dictionary
    if (sinceID) {
        [parameterDict setObject:[sinceID stringValue] forKey:@"since_id"];
    }
    
    if (maxID) {
        [parameterDict setObject:[maxID stringValue] forKey:@"max_id"];
    }
    
    if (count) {
        [parameterDict setObject:[count stringValue] forKey:@"count"];
    }
    
    if (trimUser) {
        [parameterDict setObject:@"true" forKey:@"trim_user"];
    }
    else {
        [parameterDict setObject:@"false" forKey:@"trim_user"];
    }
    
    if (includeEntities) {
        [parameterDict setObject:@"true" forKey:@"include_entities"];
    }
    else {
        [parameterDict setObject:@"false" forKey:@"include_entities"];
    }
    
    // Create Request
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:STwitterRequestMethodGET];
    request.OAuthToken = [[NSDictionary alloc] initWithObjectsAndKeys:oAuthConsumerKey, @"OAuthConsumerKey", oAuthConsumerSecret, @"OAuthConsumerSecret", oAuthAccessToken, @"OAuthAccessToken", oAuthAccessTokenSecret, @"OAuthAccessTokenSecret", nil];
    
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

+ (id)getMentionsWithAccount:(ACAccount *)account sinceID:(NSNumber *)sinceID maxID:(NSNumber *)maxID count:(NSNumber *)count trimUser:(BOOL)trimUser includeRetweets:(BOOL)includeRetweets includeEntities:(BOOL)includeEntities error:(NSError **)error
{
    // Declare Variables
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/mentions.json"];
    
    // Make Parameter Dictionary
    if (sinceID) {
        [parameterDict setObject:[sinceID stringValue] forKey:@"since_id"];
    }
    
    if (maxID) {
        [parameterDict setObject:[maxID stringValue] forKey:@"max_id"];
    }
    
    if (count) {
        [parameterDict setObject:[count stringValue] forKey:@"count"];
    }
    
    if (trimUser) {
        [parameterDict setObject:@"true" forKey:@"trim_user"];
    }
    else {
        [parameterDict setObject:@"false" forKey:@"trim_user"];
    }
    
    if (includeRetweets) {
        [parameterDict setObject:@"true" forKey:@"include_rts"];
    }
    else {
        [parameterDict setObject:@"false" forKey:@"include_rts"];
    }
    
    if (includeEntities) {
        [parameterDict setObject:@"true" forKey:@"include_entities"];
    }
    else {
        [parameterDict setObject:@"false" forKey:@"include_entities"];
    }
    
    // Create Request
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:STwitterRequestMethodGET];
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

+ (id)getMentionsWithOAuthConsumerKey:(NSString *)oAuthConsumerKey oAuthConsumerSecret:(NSString *)oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret sinceID:(NSNumber *)sinceID maxID:(NSNumber *)maxID count:(NSNumber *)count trimUser:(BOOL)trimUser includeRetweets:(BOOL)includeRetweets includeEntities:(BOOL)includeEntities error:(NSError **)error {
    // Declare Variables
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/mentions.json"];
    
    // Make Parameter Dictionary
    if (sinceID) {
        [parameterDict setObject:[sinceID stringValue] forKey:@"since_id"];
    }
    
    if (maxID) {
        [parameterDict setObject:[maxID stringValue] forKey:@"max_id"];
    }
    
    if (count) {
        [parameterDict setObject:[count stringValue] forKey:@"count"];
    }
    
    if (trimUser) {
        [parameterDict setObject:@"true" forKey:@"trim_user"];
    }
    else {
        [parameterDict setObject:@"false" forKey:@"trim_user"];
    }
    
    if (includeRetweets) {
        [parameterDict setObject:@"true" forKey:@"include_rts"];
    }
    else {
        [parameterDict setObject:@"false" forKey:@"include_rts"];
    }
    
    if (includeEntities) {
        [parameterDict setObject:@"true" forKey:@"include_entities"];
    }
    else {
        [parameterDict setObject:@"false" forKey:@"include_entities"];
    }
    
    
    // Create Request
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:STwitterRequestMethodGET];
    request.OAuthToken = [[NSDictionary alloc] initWithObjectsAndKeys:oAuthConsumerKey, @"OAuthConsumerKey", oAuthConsumerSecret, @"OAuthConsumerSecret", oAuthAccessToken, @"OAuthAccessToken", oAuthAccessTokenSecret, @"OAuthAccessTokenSecret", nil];
    
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

@end
