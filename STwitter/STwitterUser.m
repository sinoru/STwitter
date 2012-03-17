//
//  STwitterUser.m
//  TweetBlast
//
//  Created by Sinoru on 11. 4. 5..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "STwitterUser.h"

#import "STwitterOAuthTool.h"
#import "NSString (RFC3875PercentEscapes).h"


@implementation STwitterUser

@synthesize getUserProfileImageActiveDownload;
@synthesize getUserProfileImageResponse;
@synthesize getUserProfileImageResult;
@synthesize getUserProfileImageConnection;
@synthesize getUserProfileImageURLConnection;

- (NSDictionary *)getUserProfileImageAndURLWithScreenName:(NSString *)screenName size:(NSString *)size
{
    NSMutableDictionary *httpBodyParameterDict;
    NSData *httpBodyParameterData;
    NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1/users/profile_image/%@.json", screenName]];
    
    // Make HTTP Body Dictionary and Data
    if (size) {
        STwitterOAuthTool *sTwitterOAuthTool = [[STwitterOAuthTool alloc] init];
        httpBodyParameterDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[size stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding], [@"size" stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding], nil];
        httpBodyParameterData = [[sTwitterOAuthTool generateHTTPBodyString:httpBodyParameterDict] dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    // Create Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    
    // Set HTTP Method to POST
    [request setHTTPMethod:@"POST"];
    
    // Set HTTP Body
    if (size)
        [request setHTTPBody:httpBodyParameterData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.getUserProfileImageConnection = connection;
    
    if (getUserProfileImageConnection)
    {
        getUserProfileImageActiveDownload = [[NSMutableData alloc] init];
        
        while (getUserProfileImageConnection && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
        
        if (getUserProfileImageResult) {
            return [NSDictionary dictionaryWithObjectsAndKeys:getUserProfileImageResult, @"image", [getUserProfileImageResponse URL], @"url", nil];
        }
        else {
            return nil;
        }
    }
    else {
        return nil;
    }
}

- (NSURL *)getUserProfileImageURLWithScreenName:(NSString *)screenName size:(NSString *)size
{
    NSMutableDictionary *httpBodyParameterDict;
    NSData *httpBodyParameterData;
    NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1/users/profile_image/%@.json", screenName]];
    
    // Make HTTP Body Dictionary and Data
    if (size) {
        STwitterOAuthTool *sTwitterOAuthTool = [[STwitterOAuthTool alloc] init];
        httpBodyParameterDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[size stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding], [@"size" stringByAddingRFC3875PercentEscapesUsingEncoding:NSUTF8StringEncoding], nil];
        httpBodyParameterData = [[sTwitterOAuthTool generateHTTPBodyString:httpBodyParameterDict] dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    // Create Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:apiURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    
    // Set HTTP Method to POST
    [request setHTTPMethod:@"POST"];
    
    // Set HTTP Body
    if (size)
        [request setHTTPBody:httpBodyParameterData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.getUserProfileImageURLConnection = connection;
    
    if (getUserProfileImageURLConnection)
    {
        while (getUserProfileImageURLConnection && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
        
        if (getUserProfileImageResult) {
            return [getUserProfileImageResponse URL];
        }
        else {
            return nil;
        }
    }
    else {
        return nil;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.getUserProfileImageResponse = response;
    
    if (connection == getUserProfileImageURLConnection)
        self.getUserProfileImageURLConnection = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [getUserProfileImageActiveDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", [error localizedDescription]);
    
    self.getUserProfileImageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    getUserProfileImageResult = [[NSData alloc] initWithData:getUserProfileImageActiveDownload];
    
    self.getUserProfileImageConnection = nil;
}

@end
