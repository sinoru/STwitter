//
//  STwitterTweets+media.m
//  STwitter
//
//  Created by Sinoru on 12. 3. 5..
//  Copyright (c) 2012년 Sinoru. All rights reserved.
//

#import "STwitterTweets+media.h"

#import "STwitter.h"
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

+ (id)statusUpdate:(NSString *)status withMediaDatas:(NSArray *)mediaDatas mediaTypes:(NSArray *)mediaTypes OAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret OAuthAccessToken:(NSString *)OAuthAccessToken OAuthAccessTokenSecret:(NSString *)OAuthAccessTokenSecret inReplyToStatusID:(NSNumber *)inReplyToStatusID error:(out NSError **)error
{
    NSURL *apiURL = [NSURL URLWithString:@"https://upload.twitter.com/1/statuses/update_with_media.json"];
    
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:nil requestMethod:STwitterRequestMethodPOST];
    request.OAuthToken = [[NSDictionary alloc] initWithObjectsAndKeys:OAuthConsumerKey, kOAuthConsumerKey, OAuthConsumerSecret, kOAuthConsumerSecret, OAuthAccessToken, kOAuthToken, OAuthAccessTokenSecret, kOAuthTokenSecret, nil];
    
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
                
                *error = [[NSError alloc] initWithDomain:STwitterErrorDomain code:errorCode userInfo:[NSDictionary dictionaryWithObject:errorDescription forKey:NSLocalizedDescriptionKey]];
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
