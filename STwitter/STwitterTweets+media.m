//
//  STwitterTweets+media.m
//  STwitter
//
//  Created by Sinoru on 12. 3. 5..
//  Copyright (c) 2012년 Sinoru. All rights reserved.
//

#import "STwitterTweets+media.h"

#import "STwitterOAuthTool.h"
#import "STwitterRequest.h"
#import "NSString (RFC3875PercentEscapes).h"
#import "SBJson/SBJson.h"

@implementation STwitterTweets (media)

+ (id)statusUpdate:(NSString *)status withMediaDatas:(NSArray *)mediaDatas mediaTypes:(NSArray *)mediaTypes account:(ACAccount *)account inReplyToStatusID:(NSNumber *)inReplyToStatusID error:(out NSError **)error
{
    NSURL *apiURL = [NSURL URLWithString:@"https://upload.twitter.com/1/statuses/update_with_media.json"];
    
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:nil requestMethod:STwitterRequestMethodPOST];
    request.account = account;
    
    if (status) {
        [request addMultiPartData:[status dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"text/plain"];
    }
    if (inReplyToStatusID) {
        [request addMultiPartData:[[inReplyToStatusID stringValue] dataUsingEncoding:NSUTF8StringEncoding] withName:@"in_reply_to_status_id" type:@"text/plain"];
    }
    
    NSAssert([mediaDatas count] == [mediaTypes count], @"TweetBlast is Dead. Mismatch.");
    
    for (NSData *imageData in mediaDatas) {
        NSUInteger index = [mediaDatas indexOfObject:imageData];
        
        NSString *name = @"media[]";
        NSString *type = [mediaTypes objectAtIndex:index];
        
        [request addMultiPartData:imageData withName:name type:type];
    }
    
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

+ (id)statusUpdate:(NSString *)status withMediaDatas:(NSArray *)mediaDatas mediaTypes:(NSArray *)mediaTypes oAuthConsumerKey:oAuthConsumerKey oAuthConsumerSecret:oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret inReplyToStatusID:(NSNumber *)inReplyToStatusID error:(out NSError **)error
{
    NSURL *apiURL = [NSURL URLWithString:@"https://upload.twitter.com/1/statuses/update_with_media.json"];
    
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:nil requestMethod:STwitterRequestMethodPOST];
    request.OAuthToken = [[NSDictionary alloc] initWithObjectsAndKeys:oAuthConsumerKey, @"OAuthConsumerKey", oAuthConsumerSecret, @"OAuthConsumerSecret", oAuthAccessToken, @"OAuthToken", oAuthAccessTokenSecret, @"OAuthTokenSecret", nil];
    
    if (status) {
        [request addMultiPartData:[status dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"text/plain"];
    }
    if (inReplyToStatusID) {
        [request addMultiPartData:[[inReplyToStatusID stringValue] dataUsingEncoding:NSUTF8StringEncoding] withName:@"inReplyToStatusID" type:@"text/plain"];
    }
    
    NSAssert([mediaDatas count] == [mediaTypes count], @"Media Datas and Types dismatch.");
    
    for (NSData *imageData in mediaDatas) {
        NSUInteger index = [mediaDatas indexOfObject:imageData];
        
        NSString *name = @"media[]";
        NSString *type = [mediaTypes objectAtIndex:index];
        
        [request addMultiPartData:imageData withName:name type:type];
    }
    
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
