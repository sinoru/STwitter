//
//  STwitterRequest.m
//  STwitter
//
//  Created by Sinoru on 12. 2. 13..
//  Copyright (c) 2012년 Sinoru. All rights reserved.
//

#import "STwitterRequest.h"

#import "STwitterOAuthTool.h"

NSString* const kOAuthConsumerKey = @"OAuthConsumerKey";
NSString* const kOAuthConsumerSecret = @"OAuthConsumerSecret";
NSString* const kOAuthToken = @"OAuthToken";
NSString* const kOAuthTokenSecret = @"OAuthTokenSecret";

@interface STwitterRequest () {
    NSArray *_multiPartDatas;
    NSArray *_multiPartNames;
    NSArray *_multiPartTypes;
}

@end

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

- (void)addMultiPartData:(NSData *)data withName:(NSString *)name type:(NSString *)type
{
    if (!_multiPartDatas)
        _multiPartDatas = [[NSArray alloc] initWithObjects:(data ? data : Nil), nil];
    else 
        _multiPartDatas = [_multiPartDatas arrayByAddingObject:(data ? data : Nil)];
    
    if (!_multiPartNames)
        _multiPartNames = [[NSArray alloc] initWithObjects:(name ? name : Nil), nil];
    else 
        _multiPartNames = [_multiPartNames arrayByAddingObject:(name ? name : Nil)];
    
    if (!_multiPartTypes)
        _multiPartTypes = [[NSArray alloc] initWithObjects:(type ? type : Nil), nil];
    else
        _multiPartTypes = [_multiPartTypes arrayByAddingObject:(type ? type : Nil)];
}

- (NSURLRequest *)signedURLRequest
{
    NSURLRequest *request = nil;
    
    #ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    
    if ([TWRequest class] && !self.OAuthToken) {
        TWRequestMethod twitterRequestMethod;
        
        switch (self.requestMethod) {
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
        
        if (self.account)
            twitterRequest.account = _account;
        
        if (_multiPartDatas) {
            for (NSData *data in _multiPartDatas) {
                @autoreleasepool {
                    NSUInteger index = [_multiPartDatas indexOfObject:data];
                    
                    NSString *name = [_multiPartNames objectAtIndex:index];
                    NSString *type = [_multiPartTypes objectAtIndex:index];
                    
                    [twitterRequest addMultiPartData:data withName:name type:type];
                }
            }
        }
        
        request = [twitterRequest signedURLRequest];
    }
    else {
        NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:_URL];
        
        switch (self.requestMethod) {
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
        
        if (self.OAuthToken) {
            NSString *OAuthConsumerKey = [self.OAuthToken objectForKey:kOAuthConsumerKey];
            NSString *OAuthConsumerSecret = [self.OAuthToken objectForKey:kOAuthConsumerSecret];
            NSString *OAuthToken = [self.OAuthToken objectForKey:kOAuthToken];
            NSString *OAuthTokenSecret = [self.OAuthToken objectForKey:kOAuthTokenSecret];
            NSString *OAuthSignatureMethod = @"HMAC-SHA1";
            NSString *OAuthVersion = @"1.0a";
            
            NSString *HTTPAuthorizationHeader = [STwitterOAuthTool generateHTTPOAuthHeaderStringWithOAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret OAuthToken:OAuthToken OAuthTokenSecret:OAuthTokenSecret OAuthSignatureMethod:OAuthSignatureMethod OAuthVersion:OAuthVersion httpMethod:mutableRequest.HTTPMethod apiURL:mutableRequest.URL parameters:self.parameters];
            
            [mutableRequest setValue:HTTPAuthorizationHeader forHTTPHeaderField:@"Authorization"];
        }
        
        switch (self.requestMethod) {
            case STwitterRequestMethodDELETE:
            case STwitterRequestMethodGET:
                if (self.parameters) {
                    NSString *HTTPBodyParameterString = [STwitterOAuthTool generateHTTPBodyString:self.parameters];
                    mutableRequest.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [self.URL absoluteString], HTTPBodyParameterString]];
                }
                
                break;
            case STwitterRequestMethodPOST:
                if (_multiPartDatas) {
                    NSString *boundary = @"0xN0b0dy_lik3s_a_mim3__AKhSmhMrH";
                    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
                    [mutableRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
                    
                    NSData *HTTPBodyData = [STwitterOAuthTool generateHTTPBodyDataWithMultiPartDatas:_multiPartDatas multiPartNames:_multiPartNames multiPartTypes:_multiPartTypes boundary:boundary];
                    
                    mutableRequest.HTTPBody = HTTPBodyData;
                    
                    [mutableRequest addValue:[NSString stringWithFormat:@"%ul", [HTTPBodyData length]] forHTTPHeaderField:@"Content-Length"];
                }
                else if (self.parameters) {
                    NSString *HTTPBodyParameterString = [STwitterOAuthTool generateHTTPBodyString:self.parameters];
                    mutableRequest.HTTPBody = [HTTPBodyParameterString dataUsingEncoding:NSUTF8StringEncoding];
                }
                break;
        }
        
        request = [mutableRequest copy];
    }
    
    #else
    
    {
        NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:_URL];
        
        switch (self.requestMethod) {
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
        
        if (self.OAuthToken) {
            NSString *OAuthConsumerKey = [self.OAuthToken objectForKey:kOAuthConsumerKey];
            NSString *OAuthConsumerSecret = [self.OAuthToken objectForKey:kOAuthConsumerSecret];
            NSString *OAuthToken = [self.OAuthToken objectForKey:kOAuthToken];
            NSString *OAuthTokenSecret = [self.OAuthToken objectForKey:kOAuthTokenSecret];
            NSString *OAuthSignatureMethod = @"HMAC-SHA1";
            NSString *OAuthVersion = @"1.0a";
            
            // Generate UUID for OAuth Nonce
            NSString *OAuthNonce = [STwitterOAuthTool generateUUID];
            
            // Generate Time Stamp
            NSString *OAuthTimestamp = [NSString stringWithFormat:@"%i" , [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] intValue]];
            
            // Make OAuth Arguemnt Dictionary
            NSMutableDictionary *OAuthArgumentDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:OAuthConsumerKey, @"oauth_consumer_key", OAuthNonce, @"oauth_nonce", OAuthSignatureMethod, @"oauth_signature_method", OAuthToken, @"oauth_token", OAuthTimestamp, @"oauth_timestamp", OAuthVersion, @"oauth_version", nil];
            
            NSMutableDictionary *OAuthSignatureDict = [OAuthArgumentDict mutableCopy];
            [OAuthSignatureDict addEntriesFromDictionary:self.parameters];
            
            NSString *OAuthSignature = nil;
            
            OAuthSignature = [STwitterOAuthTool generateOAuthSignature:OAuthSignatureDict httpMethod:mutableRequest.HTTPMethod apiURL:self.URL oAuthConsumerSecret:OAuthConsumerSecret oAuthTokenSecret:OAuthTokenSecret];
            
            [OAuthArgumentDict setObject:OAuthSignature forKey:@"oauth_signature"];
            
            NSString *HTTPAuthorizationHeader = [STwitterOAuthTool generateHTTPAuthorizationHeader:OAuthArgumentDict];
            [mutableRequest setValue:HTTPAuthorizationHeader forHTTPHeaderField:@"Authorization"];
        }
        
        switch (self.requestMethod) {
            case STwitterRequestMethodDELETE:
            case STwitterRequestMethodGET:
                if (self.parameters) {
                    NSString *HTTPBodyParameterString = [STwitterOAuthTool generateHTTPBodyString:self.parameters];
                    mutableRequest.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [self.URL absoluteString], HTTPBodyParameterString]];
                }
                
                break;
            case STwitterRequestMethodPOST:
                if (_multiPartDatas) {
                    NSString *boundary = @"0xN0b0dy_lik3s_a_mim3__AKhSmhMrH";
                    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
                    [mutableRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
                    
                    NSData *HTTPBodyData = [STwitterOAuthTool generateHTTPBodyDataWithMultiPartDatas:_multiPartDatas multiPartNames:_multiPartNames multiPartTypes:_multiPartTypes boundary:boundary];
                    
                    mutableRequest.HTTPBody = HTTPBodyData;
                    
                    [mutableRequest addValue:[NSString stringWithFormat:@"%ul", [HTTPBodyData length]] forHTTPHeaderField:@"Content-Length"];
                }
                else if (self.parameters) {
                    NSString *HTTPBodyParameterString = [STwitterOAuthTool generateHTTPBodyString:self.parameters];
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
    
    if ([TWRequest class] && !self.OAuthToken) {
        TWRequestMethod twitterRequestMethod;
        
        switch (self.requestMethod) {
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
        
        TWRequest *twitterRequest = [[TWRequest alloc] initWithURL:self.URL parameters:self.parameters requestMethod:twitterRequestMethod];
        
        if (self.account)
            twitterRequest.account = self.account;
        
        if (_multiPartDatas) {
            for (NSData *data in _multiPartDatas) {
                @autoreleasepool {
                    NSUInteger index = [_multiPartDatas indexOfObject:data];
                    
                    NSString *name = [_multiPartNames objectAtIndex:index];
                    NSString *type = [_multiPartTypes objectAtIndex:index];
                    
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
