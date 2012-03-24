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
#import "STwitterRequest.h"

@implementation STwitterFavorites

+ (id)favoriteTweet:(NSNumber *)retweetID account:(ACAccount *)account includeEntities:(BOOL)includeEntities error:(NSError **)error
{
    // Declare Variables
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/favorites/create/%@.json", retweetID]];
    
    if (includeEntities) {
        [parameterDict setObject:@"true" forKey:@"include_entities"];
    }
    
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:STwitterRequestMethodPOST];
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

+ (id)favoriteTweet:(NSNumber *)retweetID oAuthConsumerKey:oAuthConsumerKey oAuthConsumerSecret:oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret includeEntities:(BOOL)includeEntities error:(NSError **)error
{
    // Declare Variables
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/favorites/create/%@.json", retweetID]];
    
    if (includeEntities) {
        [parameterDict setObject:@"true" forKey:@"include_entities"];
    }
    
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:STwitterRequestMethodPOST];
    request.OAuthToken = [[NSDictionary alloc] initWithObjectsAndKeys:oAuthConsumerKey, @"OAuthConsumerKey", oAuthConsumerSecret, @"OAuthConsumerSecret", oAuthAccessToken, @"OAuthAccessToken", oAuthAccessTokenSecret, @"OAuthAccessTokenSecret", nil];
    
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

@end
