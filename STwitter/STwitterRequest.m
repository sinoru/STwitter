//
//  STwitterRequest.m
//  STwitter
//
//  Created by Sinoru on 12. 2. 13..
//  Copyright (c) 2012년 Sinoru. All rights reserved.
//

#import "STwitterRequest.h"

#import "STwitterOAuthTool.h"
#import "NSString (RFC3875PercentEscapes).h"

@implementation STwitterRequest

@synthesize account = _account;
@synthesize OAuthToken = _OAuthToken;
@synthesize URL = _URL;
@synthesize requestMethod = _requestMethod;
@synthesize parameters = _parameters;

- (id)initWithURL:(NSURL *)aURL parameters:(NSDictionary *)aParameters requestMethod:(STwitterRequestMethod)aSTwitterRequestMethod
{
    self = [super init];
    if (self) {
        // Custom initialization
        _URL = aURL;
        _parameters = aParameters;
        _requestMethod = aSTwitterRequestMethod;
    }
    return self;
}

- (void)setParameters:(NSDictionary *)aParameters
{
    NSMutableDictionary *percentEscapedParameters = [[NSMutableDictionary alloc] initWithCapacity:[_parameters count]];
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
    
    _parameters = [percentEscapedParameters copy];
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
    
    #ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    
    if ([TWRequest class] && !_OAuthToken) {
        TWRequestMethod twitterRequestMethod;
        
        switch (_requestMethod) {
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
        
        TWRequest *twitterRequest = [[TWRequest alloc] initWithURL:_URL parameters:_parameters requestMethod:twitterRequestMethod];
        
        if (_account)
            twitterRequest.account = _account;
        
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
    else {
        NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:_URL];
        
        switch (_requestMethod) {
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
        
        if (_OAuthToken) {
            NSString *OAuthConsumerKey = [_OAuthToken objectForKey:@"OAuthConsumerKey"];
            NSString *OAuthConsumerSecret = [_OAuthToken objectForKey:@"OAuthConsumerSecret"];
            NSString *OAuthToken = [_OAuthToken objectForKey:@"OAuthToken"];
            NSString *OAuthTokenSecret = [_OAuthToken objectForKey:@"OAuthTokenSecret"];
            NSString *OAuthSignatureMethod = @"HMAC-SHA1";
            NSString *OAuthVersion = @"1.0";
            
            // Generate UUID for OAuth Nonce
            NSString *OAuthNonce = [STwitterOAuthTool generateUUID];
            
            // Generate Time Stamp
            NSString *OAuthTimestamp = [NSString stringWithFormat:@"%i" , [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] intValue]];
            
            // Make OAuth Arguemnt Dictionary
            NSMutableDictionary *OAuthArgumentDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:OAuthConsumerKey, @"oauth_consumer_key", OAuthNonce, @"oauth_nonce", OAuthSignatureMethod, @"oauth_signature_method", OAuthToken, @"oauth_token", OAuthTimestamp, @"oauth_timestamp", OAuthVersion, @"oauth_version", nil];
            
            NSMutableDictionary *OAuthSignatureDict = [OAuthArgumentDict mutableCopy];
            [OAuthSignatureDict addEntriesFromDictionary:_parameters];
            
            NSString *OAuthSignature = nil;
            
            OAuthSignature = [STwitterOAuthTool generateOAuthSignature:OAuthSignatureDict httpMethod:mutableRequest.HTTPMethod apiURL:_URL oAuthConsumerSecret:OAuthConsumerSecret oAuthTokenSecret:OAuthTokenSecret];
            
            [OAuthArgumentDict setObject:OAuthSignature forKey:@"oauth_signature"];
            
            NSString *HTTPAuthorizationHeader = [STwitterOAuthTool generateHTTPAuthorizationHeader:OAuthArgumentDict];
            [mutableRequest setValue:HTTPAuthorizationHeader forHTTPHeaderField:@"Authorization"];
        }
        
        switch (_requestMethod) {
            case STwitterRequestMethodDELETE:
            case STwitterRequestMethodGET:
                if (_parameters) {
                    NSString *HTTPBodyParameterString = [STwitterOAuthTool generateHTTPBodyString:_parameters];
                    mutableRequest.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [_URL absoluteString], HTTPBodyParameterString]];
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
                else if (_parameters) {
                    NSString *HTTPBodyParameterString = [STwitterOAuthTool generateHTTPBodyString:_parameters];
                    mutableRequest.HTTPBody = [HTTPBodyParameterString dataUsingEncoding:NSUTF8StringEncoding];
                }
                break;
        }
        
        request = [mutableRequest copy];
    }
    
    #endif
    
    #ifdef __MAC_OS_VERSION_MAX_ALLOWED
    
    {
        NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:_URL];
        
        switch (_requestMethod) {
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
        
        if (_OAuthToken) {
            NSString *OAuthConsumerKey = [_OAuthToken objectForKey:@"OAuthConsumerKey"];
            NSString *OAuthConsumerSecret = [_OAuthToken objectForKey:@"OAuthConsumerSecret"];
            NSString *OAuthToken = [_OAuthToken objectForKey:@"OAuthToken"];
            NSString *OAuthTokenSecret = [_OAuthToken objectForKey:@"OAuthTokenSecret"];
            NSString *OAuthSignatureMethod = @"HMAC-SHA1";
            NSString *OAuthVersion = @"1.0";
            
            // Generate UUID for OAuth Nonce
            NSString *OAuthNonce = [STwitterOAuthTool generateUUID];
            
            // Generate Time Stamp
            NSString *OAuthTimestamp = [NSString stringWithFormat:@"%i" , [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] intValue]];
            
            // Make OAuth Arguemnt Dictionary
            NSMutableDictionary *OAuthArgumentDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:OAuthConsumerKey, @"oauth_consumer_key", OAuthNonce, @"oauth_nonce", OAuthSignatureMethod, @"oauth_signature_method", OAuthToken, @"oauth_token", OAuthTimestamp, @"oauth_timestamp", OAuthVersion, @"oauth_version", nil];
            
            NSMutableDictionary *OAuthSignatureDict = [OAuthArgumentDict mutableCopy];
            [OAuthSignatureDict addEntriesFromDictionary:_parameters];
            
            NSString *OAuthSignature = nil;
            
            OAuthSignature = [STwitterOAuthTool generateOAuthSignature:OAuthSignatureDict httpMethod:mutableRequest.HTTPMethod apiURL:_URL oAuthConsumerSecret:OAuthConsumerSecret oAuthTokenSecret:OAuthTokenSecret];
            
            [OAuthArgumentDict setObject:OAuthSignature forKey:@"oauth_signature"];
            
            NSString *HTTPAuthorizationHeader = [STwitterOAuthTool generateHTTPAuthorizationHeader:OAuthArgumentDict];
            [mutableRequest setValue:HTTPAuthorizationHeader forHTTPHeaderField:@"Authorization"];
        }
        
        switch (_requestMethod) {
            case STwitterRequestMethodDELETE:
            case STwitterRequestMethodGET:
                if (_parameters) {
                    NSString *HTTPBodyParameterString = [STwitterOAuthTool generateHTTPBodyString:_parameters];
                    mutableRequest.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [_URL absoluteString], HTTPBodyParameterString]];
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
                else if (_parameters) {
                    NSString *HTTPBodyParameterString = [STwitterOAuthTool generateHTTPBodyString:_parameters];
                    mutableRequest.HTTPBody = [HTTPBodyParameterString dataUsingEncoding:NSUTF8StringEncoding];
                }
                break;
        }
        
        request = [mutableRequest copy];
    }
    
    #endif
    
    return request;
}

- (void)performRequestWithHandler:(STwitterRequestHandler)handler
{
    #ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    
    if ([TWRequest class] && !_OAuthToken) {
        TWRequestMethod twitterRequestMethod;
        
        switch (_requestMethod) {
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
        
        TWRequest *twitterRequest = [[TWRequest alloc] initWithURL:_URL parameters:_parameters requestMethod:twitterRequestMethod];
        
        if (_account)
            twitterRequest.account = _account;
        
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
    else {
        NSURLRequest *request = [self signedURLRequest];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSHTTPURLResponse *urlResponse = nil;
            NSError *error = nil;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
            handler(responseData, urlResponse, error);
        });
    }
    
    #endif
    
    #ifdef __MAC_OS_VERSION_MAX_ALLOWED
    
    {
        NSURLRequest *request = [self signedURLRequest];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSHTTPURLResponse *urlResponse = nil;
            NSError *error = nil;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
            handler(responseData, urlResponse, error);
        });
    }
    
    #endif
}

@end
