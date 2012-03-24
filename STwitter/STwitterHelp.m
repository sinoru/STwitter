//
//  STwitterHelp.m
//  STwitter
//
//  Created by 강 재홍 on 12. 3. 5..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "STwitterHelp.h"

#import "STwitterRequest.h"
#import "SBJson.h"

@implementation STwitterHelp

+ (id)getConfiguration:(out NSError **)error
{
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/1/help/configuration.json"];
    
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:nil requestMethod:STwitterRequestMethodGET];
    
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
