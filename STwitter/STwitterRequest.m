//
//  STwitterRequest.m
//  STwitter
//
//  Created by 재홍 강 on 12. 2. 13..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "STwitterRequest.h"
#import "STwitterOAuthTool.h"
#import "NSString (RFC3875PercentEscapes).h"

@implementation STwitterRequest

@synthesize account;
@synthesize OAuthToken;
@synthesize URL;
@synthesize requestMethod;
@synthesize parameters;

- (id)initWithURL:(NSURL *)aURL parameters:(NSDictionary *)aParameters requestMethod:(STwitterRequestMethod)aSTwitterRequestMethod
{
    self = [super init];
    if (self) {
        // Custom initialization
        URL = aURL;
        parameters = aParameters;
        requestMethod = aSTwitterRequestMethod;
    }
    return self;
}

- (void)setParameters:(NSDictionary *)aParameters
{
    NSMutableDictionary *percentEscapedParameters = [[NSMutableDictionary alloc] initWithCapacity:[parameters count]];
    for (NSValue *key in aParameters) {
        id object = [aParameters objectForKey:key];
        
        if ([object isKindOfClass:[NSString class]]) {
            NSString *percentEscapedString = [object stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [percentEscapedParameters setObject:percentEscapedString forKey:key];
        }
        else {
            [percentEscapedParameters setObject:object forKey:key];
        }
    }
    
    parameters = [percentEscapedParameters copy];
}

- (void)addMultiPartData:(NSData *)data withName:(NSString *)name type:(NSString *)type
{
    if (!multiPartDatas)
        multiPartDatas = [[NSArray alloc] initWithObjects:(data ? data : Nil), nil];
    else 
        multiPartDatas = [multiPartDatas arrayByAddingObject:(data ? data : Nil)];
    
    if (!multiPartNames)
        multiPartNames = [[NSArray alloc] initWithObjects:(name ? name : Nil), nil];
    else 
        multiPartNames = [multiPartNames arrayByAddingObject:(name ? name : Nil)];
    
    if (!multiPartTypes)
        multiPartTypes = [[NSArray alloc] initWithObjects:(type ? type : Nil), nil];
    else
        multiPartTypes = [multiPartTypes arrayByAddingObject:(type ? type : Nil)];
}

- (NSURLRequest *)signedURLRequest
{
    NSURLRequest *request = nil;
    
    if (account) {
        TWRequestMethod twitterRequestMethod;
        
        switch (requestMethod) {
            case STwitterRequestMethodDELETE:
                twitterRequestMethod = TWRequestMethodDELETE;
                break;
            case STwitterRequestMethodGET:
                twitterRequestMethod = TWRequestMethodGET;
                break;
            case STwitterRequestMethodPOST:
                twitterRequestMethod = TWRequestMethodPOST;
                break;
        }
        
        TWRequest *twitterRequest = [[TWRequest alloc] initWithURL:URL parameters:parameters requestMethod:twitterRequestMethod];
        
        twitterRequest.account = account;
        
        if (multiPartDatas) {
            for (NSData *data in multiPartDatas) {
                @autoreleasepool {
                    NSUInteger index = [multiPartDatas indexOfObject:data];
                    
                    NSString *name = [multiPartNames objectAtIndex:index];
                    NSString *type = [multiPartTypes objectAtIndex:index];
                    
                    [twitterRequest addMultiPartData:data withName:name type:type];
                }
            }
        }
        
        request = [twitterRequest signedURLRequest];
    }
    else if (OAuthToken) {
        NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
        
        NSString *OAuthConsumerKey = [OAuthToken objectForKey:@"OAuthConsumerKey"];
        NSString *OAuthConsumerSecret = [OAuthToken objectForKey:@"OAuthConsumerSecret"];
        NSString *OAuthAccessToken = [OAuthToken objectForKey:@"OAuthAccessToken"];
        NSString *OAuthAccessTokenSecret = [OAuthToken objectForKey:@"OAuthAccessTokenSecret"];
        NSString *OAuthSignatureMethod = @"HMAC-SHA1";
        NSString *OAuthVersion = @"1.0";
        
        // Generate UUID for OAuth Nonce
        NSString *OAuthNonce = [STwitterOAuthTool generateUUID];
        
        // Generate Time Stamp
        NSString *OAuthTimestamp = [NSString stringWithFormat:@"%i" , [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] intValue]];
        
        // Make OAuth Arguemnt Dictionary
        NSMutableDictionary *OAuthArgumentDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:OAuthConsumerKey, @"oauth_consumer_key", OAuthNonce, @"oauth_nonce", OAuthSignatureMethod, @"oauth_signature_method", OAuthAccessToken, @"oauth_token", OAuthTimestamp, @"oauth_timestamp", OAuthVersion, @"oauth_version", nil];
        
        NSMutableDictionary *OAuthSignatureDict = [OAuthArgumentDict mutableCopy];
        [OAuthSignatureDict addEntriesFromDictionary:parameters];
        
        NSString *OAuthSignature = nil;
        
        switch (requestMethod) {
            case STwitterRequestMethodDELETE:
                mutableRequest.HTTPMethod = @"DELETE";
                break;
            case STwitterRequestMethodGET:
                mutableRequest.HTTPMethod = @"GET";
                break;
            case STwitterRequestMethodPOST:
                mutableRequest.HTTPMethod = @"POST";
                break;
        }
        
        OAuthSignature = [STwitterOAuthTool generateOAuthSignature:OAuthSignatureDict httpMethod:mutableRequest.HTTPMethod apiURL:URL oAuthConsumerSecret:OAuthConsumerSecret oAuthTokenSecret:OAuthAccessTokenSecret];
        
        [OAuthArgumentDict setObject:OAuthSignature forKey:@"oauth_signature"];
        
        NSString *HTTPAuthorizationHeader = [STwitterOAuthTool generateHTTPAuthorizationHeader:OAuthArgumentDict];
        [mutableRequest setValue:HTTPAuthorizationHeader forHTTPHeaderField:@"Authorization"];
        
        switch (requestMethod) {
            case STwitterRequestMethodDELETE:
            case STwitterRequestMethodGET:
                if (parameters) {
                    NSString *HTTPBodyParameterString = [STwitterOAuthTool generateHTTPBodyString:parameters];
                    mutableRequest.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [URL absoluteString], HTTPBodyParameterString]];
                }
                break;
            case STwitterRequestMethodPOST:
                if (multiPartDatas) {
                    NSString *boundary = @"0xN0b0dy_lik3s_a_mim3__AKhSmhMrH";
                    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
                    [mutableRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
                    
                    NSData *HTTPBodyData = [STwitterOAuthTool generateHTTPBodyDataWithMultiPartDatas:multiPartDatas multiPartNames:multiPartNames multiPartTypes:multiPartTypes boundary:boundary];
                    
                    mutableRequest.HTTPBody = HTTPBodyData;
                    
                    [mutableRequest addValue:[NSString stringWithFormat:@"%d", [HTTPBodyData length]] forHTTPHeaderField:@"Content-Length"];
                }
                else if (parameters) {
                    NSString *HTTPBodyParameterString = [STwitterOAuthTool generateHTTPBodyString:parameters];
                    mutableRequest.HTTPBody = [HTTPBodyParameterString dataUsingEncoding:NSUTF8StringEncoding];
                }
                break;
        }
        
        request = [mutableRequest copy];
    }
    
    return request;
}

- (void)performRequestWithHandler:(STwitterRequestHandler)handler
{
    if (account) {
        TWRequestMethod twitterRequestMethod;
        
        switch (requestMethod) {
            case STwitterRequestMethodDELETE:
                twitterRequestMethod = TWRequestMethodDELETE;
                break;
            case STwitterRequestMethodGET:
                twitterRequestMethod = TWRequestMethodGET;
                break;
            case STwitterRequestMethodPOST:
                twitterRequestMethod = TWRequestMethodPOST;
                break;
        }
        
        TWRequest *twitterRequest = [[TWRequest alloc] initWithURL:URL parameters:parameters requestMethod:twitterRequestMethod];
        
        twitterRequest.account = account;
        
        if (multiPartDatas) {
            for (NSData *data in multiPartDatas) {
                @autoreleasepool {
                    NSUInteger index = [multiPartDatas indexOfObject:data];
                    
                    NSString *name = [multiPartNames objectAtIndex:index];
                    NSString *type = [multiPartTypes objectAtIndex:index];
                    
                    [twitterRequest addMultiPartData:data withName:name type:type];
                }
            }
        }
        
        [twitterRequest performRequestWithHandler:handler];
    }
    else if (OAuthToken) {
        NSURLRequest *request = [self signedURLRequest];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSHTTPURLResponse *urlResponse = nil;
            NSError *error = nil;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
            handler(responseData, urlResponse, error);
        });
    }
}

@end
