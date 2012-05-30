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

@property (nonatomic, readwrite) STwitterRequestMethod requestMethod;
@property (nonatomic, readwrite) NSURL *URL;
@property (nonatomic, readwrite) NSDictionary *parameters;

@end

@implementation STwitterRequest

@synthesize account = _account;
@synthesize OAuthToken = _OAuthToken;
@synthesize URL = _URL;
@synthesize requestMethod = _requestMethod;
@synthesize requestCompressionType = _requestCompressionType;
@synthesize parameters = _parameters;

- (id)initWithURL:(NSURL *)aURL parameters:(NSDictionary *)aParameters requestMethod:(STwitterRequestMethod)aSTwitterRequestMethod
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.URL = aURL;
        self.parameters = aParameters;
        self.requestMethod = aSTwitterRequestMethod;
        self.requestCompressionType = STwitterRequestCompressionNone;
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
    
    
    #if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0)
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
        
        NSMutableURLRequest *temporaryRequest = [[twitterRequest signedURLRequest] mutableCopy];
        
        switch (self.requestCompressionType) {
            case STwitterRequestCompressionNone:
                break;
            case STwitterRequestCompressionGzip:
                [temporaryRequest setValue:@"deflate, gzip" forHTTPHeaderField:@"Accept-Encoding"];
                break;
        }
        
        request = [temporaryRequest copy];
    }
    #elif (__MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_10_8)
    if ([SLRequest class] && !self.OAuthToken) {
        SLRequestMethod socialRequestMethod;
        
        switch (self.requestMethod) {
            case STwitterRequestMethodDELETE:
                socialRequestMethod = SLRequestMethodDELETE;
                break;
            case STwitterRequestMethodGET:
                socialRequestMethod = SLRequestMethodGET;
                break;
            case STwitterRequestMethodPOST:
                socialRequestMethod = SLRequestMethodPOST;
                break;
        }
        
        SLRequest *socialRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:socialRequestMethod URL:_URL parameters:_parameters];
        
        if (self.account)
            socialRequest.account = _account;
        
        if (_multiPartDatas) {
            for (NSData *data in _multiPartDatas) {
                @autoreleasepool {
                    NSUInteger index = [_multiPartDatas indexOfObject:data];
                    
                    NSString *name = [_multiPartNames objectAtIndex:index];
                    NSString *type = [_multiPartTypes objectAtIndex:index];
                    
                    [socialRequest addMultipartData:data withName:name type:type];
                }
            }
        }
        
        NSMutableURLRequest *temporaryRequest = [[socialRequest preparedURLRequest] mutableCopy];
        
        switch (self.requestCompressionType) {
            case STwitterRequestCompressionNone:
                break;
            case STwitterRequestCompressionGzip:
                [temporaryRequest setValue:@"deflate, gzip" forHTTPHeaderField:@"Accept-Encoding"];
                break;
        }
        
        request = [temporaryRequest copy];
    }
    #endif
    
    if (!request) {
        NSMutableURLRequest *temporaryRequest = [[NSMutableURLRequest alloc] initWithURL:_URL];
        
        switch (self.requestMethod) {
            case STwitterRequestMethodDELETE:
                temporaryRequest.HTTPMethod = @"DELETE";
                break;
            case STwitterRequestMethodGET:
                temporaryRequest.HTTPMethod = @"GET";
                break;
            case STwitterRequestMethodPOST:
                temporaryRequest.HTTPMethod = @"POST";
                break;
        }
        
        if (self.OAuthToken) {
            NSString *OAuthConsumerKey = [self.OAuthToken objectForKey:kOAuthConsumerKey];
            NSString *OAuthConsumerSecret = [self.OAuthToken objectForKey:kOAuthConsumerSecret];
            NSString *OAuthToken = [self.OAuthToken objectForKey:kOAuthToken];
            NSString *OAuthTokenSecret = [self.OAuthToken objectForKey:kOAuthTokenSecret];
            NSString *OAuthSignatureMethod = @"HMAC-SHA1";
            NSString *OAuthVersion = @"1.0a";
            
            NSString *HTTPAuthorizationHeader = [STwitterOAuthTool generateHTTPOAuthHeaderStringWithOAuthConsumerKey:OAuthConsumerKey OAuthConsumerSecret:OAuthConsumerSecret OAuthToken:OAuthToken OAuthTokenSecret:OAuthTokenSecret OAuthSignatureMethod:OAuthSignatureMethod OAuthVersion:OAuthVersion httpMethod:temporaryRequest.HTTPMethod apiURL:temporaryRequest.URL parameters:self.parameters];
            
            [temporaryRequest setValue:HTTPAuthorizationHeader forHTTPHeaderField:@"Authorization"];
        }
        
        switch (self.requestMethod) {
            case STwitterRequestMethodDELETE:
            case STwitterRequestMethodGET:
                if (self.parameters) {
                    NSString *HTTPBodyParameterString = [STwitterOAuthTool generateHTTPBodyString:self.parameters];
                    temporaryRequest.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [self.URL absoluteString], HTTPBodyParameterString]];
                }
                
                break;
            case STwitterRequestMethodPOST:
                if (_multiPartDatas) {
                    NSString *boundary = @"0xN0b0dy_lik3s_a_mim3__AKhSmhMrH";
                    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
                    [temporaryRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
                    
                    NSData *HTTPBodyData = [STwitterOAuthTool generateHTTPBodyDataWithMultiPartDatas:_multiPartDatas multiPartNames:_multiPartNames multiPartTypes:_multiPartTypes boundary:boundary];
                    
                    temporaryRequest.HTTPBody = HTTPBodyData;
                    
                    [temporaryRequest addValue:[NSString stringWithFormat:@"%ul", [HTTPBodyData length]] forHTTPHeaderField:@"Content-Length"];
                }
                else if (self.parameters) {
                    NSString *HTTPBodyParameterString = [STwitterOAuthTool generateHTTPBodyString:self.parameters];
                    temporaryRequest.HTTPBody = [HTTPBodyParameterString dataUsingEncoding:NSUTF8StringEncoding];
                }
                break;
        }
        
        switch (self.requestCompressionType) {
            case STwitterRequestCompressionNone:
                break;
            case STwitterRequestCompressionGzip:
                [temporaryRequest setValue:@"deflate, gzip" forHTTPHeaderField:@"Accept-Encoding"];
                break;
        }
        
        request = [temporaryRequest copy];
    }
    
    return request;
}

- (void)performRequestWithHandler:(STwitterRequestHandler)handler
{
    NSURLRequest *request = [self signedURLRequest];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        handler(responseData, urlResponse, error);
    });
}

@end
