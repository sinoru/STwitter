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

- (NSURLRequest *)signedURLRequest
{
    NSURLRequest *request = nil;
    
    if (account) {
        TWRequestMethod twitterRequestMethod;
        
        if (requestMethod == STwitterRequestMethodDELETE) {
            twitterRequestMethod = TWRequestMethodDELETE;
        } else if (requestMethod == STwitterRequestMethodGET) {
            twitterRequestMethod = TWRequestMethodGET;
        } else if (requestMethod == STwitterRequestMethodPOST) {
            twitterRequestMethod = TWRequestMethodPOST;
        }
        
        TWRequest *twitterRequest = [[TWRequest alloc] initWithURL:URL parameters:parameters requestMethod:twitterRequestMethod];
        
        twitterRequest.account = account;
        
        request = [twitterRequest signedURLRequest];
    }
    else if (OAuthToken) {
        STwitterOAuthTool *sTwitterOAuthTool = [[STwitterOAuthTool alloc] init];
        NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
        NSString *OAuthConsumerKey = [OAuthToken objectForKey:@"OAuthConsumerKey"];
        NSString *OAuthConsumerSecret = [OAuthToken objectForKey:@"OAuthConsumerSecret"];
        NSString *OAuthAccessToken = [OAuthToken objectForKey:@"OAuthAccessToken"];
        NSString *OAuthAccessTokenSecret = [OAuthToken objectForKey:@"OAuthAccessTokenSecret"];
        NSString *OAuthSignatureMethod = @"HMAC-SHA1";
        NSString *OAuthVersion = @"1.0";
        
        // Generate UUID for OAuth Nonce
        NSString *OAuthNonce = [sTwitterOAuthTool generateUUID];
        
        // Generate Time Stamp
        NSString *OAuthTimestamp = [NSString stringWithFormat:@"%i" , [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] intValue]];
        
        // Make OAuth Arguemnt Dictionary
        NSMutableDictionary *OAuthArgumentDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:OAuthConsumerKey, @"oauth_consumer_key", OAuthNonce, @"oauth_nonce", OAuthSignatureMethod, @"oauth_signature_method", OAuthAccessToken, @"oauth_token", OAuthTimestamp, @"oauth_timestamp", OAuthVersion, @"oauth_version", nil];
        
        NSMutableDictionary *OAuthSignatureDict = [OAuthArgumentDict mutableCopy];
        [OAuthSignatureDict addEntriesFromDictionary:parameters];
        
        NSString *OAuthSignature = nil;
        
        if (requestMethod == STwitterRequestMethodDELETE) {
            OAuthSignature = [sTwitterOAuthTool generateOAuthSignature:OAuthSignatureDict httpMethod:@"DELETE" apiURL:URL oAuthConsumerSecret:OAuthConsumerSecret oAuthTokenSecret:OAuthAccessTokenSecret];
        } else if (requestMethod == STwitterRequestMethodGET) {
            OAuthSignature = [sTwitterOAuthTool generateOAuthSignature:OAuthSignatureDict httpMethod:@"GET" apiURL:URL oAuthConsumerSecret:OAuthConsumerSecret oAuthTokenSecret:OAuthAccessTokenSecret];
        } else if (requestMethod == STwitterRequestMethodPOST) {
            OAuthSignature = [sTwitterOAuthTool generateOAuthSignature:OAuthSignatureDict httpMethod:@"POST" apiURL:URL oAuthConsumerSecret:OAuthConsumerSecret oAuthTokenSecret:OAuthAccessTokenSecret];
        }
        
        [OAuthArgumentDict setObject:OAuthSignature forKey:@"oauth_signature"];
        
        NSString *HTTPAuthorizationHeader = [sTwitterOAuthTool generateHTTPAuthorizationHeader:OAuthArgumentDict];
        [mutableRequest setValue:HTTPAuthorizationHeader forHTTPHeaderField:@"Authorization"];
        
        NSString *HTTPBodyParameterString = [sTwitterOAuthTool generateHTTPBody:parameters];
        
        if (requestMethod == STwitterRequestMethodDELETE) {
            if (HTTPBodyParameterString) {
                mutableRequest.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [URL absoluteString], HTTPBodyParameterString]];
            }
        } else if (requestMethod == STwitterRequestMethodGET) {
            if (HTTPBodyParameterString) {
                mutableRequest.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [URL absoluteString], HTTPBodyParameterString]];
            }
        } else if (requestMethod == STwitterRequestMethodPOST) {
            if (HTTPBodyParameterString) {
                mutableRequest.HTTPBody = [HTTPBodyParameterString dataUsingEncoding:NSUTF8StringEncoding];
            }
        }
        
        request = [mutableRequest copy];
    }
    
    return request;
}

@end
