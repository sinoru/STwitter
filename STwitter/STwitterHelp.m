//
//  STwitterHelp.m
//  STwitter
//
//  Created by Sinoru on 12. 3. 5..
//  Copyright (c) 2012년 Sinoru. All rights reserved.
//

#import "STwitterHelp.h"

#import "STwitter.h"
#import "SBJson/SBJson.h"

@implementation STwitterHelp

+ (id)getConfiguration:(out NSError **)error
{
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/1/help/configuration.json"];
    
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:nil requestMethod:STwitterRequestMethodGET];
    
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
                if ([parsedObject objectForKey:@"errors"]) {
                    NSInteger errorCode;
                    NSString *errorDescription;
                    
                    if ([[parsedObject objectForKey:@"error"] objectForKey:@"code"])
                        errorCode = [[[parsedObject objectForKey:@"error"] objectForKey:@"code"] integerValue];
                    else
                        errorCode = [response statusCode];
                    
                    if ([[parsedObject objectForKey:@"error"] objectForKey:@"message"])
                        errorDescription = [[parsedObject objectForKey:@"error"] objectForKey:@"message"];
                    else
                        if ([[parsedObject objectForKey:@"error"] isKindOfClass:[NSString class]])
                            errorDescription = [parsedObject objectForKey:@"error"];
                    
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
