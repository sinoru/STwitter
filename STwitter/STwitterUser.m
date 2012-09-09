//
//  STwitterUser.m
//  STwitter
//
//  Created by Sinoru on 11. 4. 5..
//  Copyright 2011 Sinoru. All rights reserved.
//

#import "STwitterUser.h"


@implementation STwitterUser

@synthesize getUserProfileImageResponse;
@synthesize getUserProfileImageURLConnection;

- (NSDictionary *)getUserProfileImageAndURLWithScreenName:(NSString *)screenName size:(NSString *)size
{
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc] init];
    NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1/users/profile_image/%@.json", screenName]];
    
    // Make HTTP Body Dictionary and Data
    if (size) {
        [parameterDict setObject:size forKey:@"size"];
    }
    
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:STwitterRequestMethodPOST];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:[request signedURLRequest] returningResponse:&response error:&error];
    
    if (!error && receivedData) {
        return [NSDictionary dictionaryWithObjectsAndKeys:receivedData, @"image", [response URL], @"url", nil];
    }
    
    return nil;
}

- (NSDictionary *)getUserProfileImageAndURLWithUserID:(NSNumber *)userID size:(NSString *)size
{
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc] init];
    NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1/users/profile_image"]];
    
    // Make HTTP Body Dictionary and Data
    if (userID) {
        [parameterDict setObject:[userID stringValue] forKey:@"user_id"];
    }
    if (size) {
        [parameterDict setObject:size forKey:@"size"];
    }
    
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:STwitterRequestMethodPOST];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:[request signedURLRequest] returningResponse:&response error:&error];
    
    if (!error && receivedData) {
        return [NSDictionary dictionaryWithObjectsAndKeys:receivedData, @"image", [response URL], @"url", nil];
    }
    
    return nil;
}

- (NSURL *)getUserProfileImageURLWithScreenName:(NSString *)screenName size:(NSString *)size
{
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc] init];
    NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1/users/profile_image/%@.json", screenName]];
    
    // Make HTTP Body Dictionary and Data
    if (size) {
        [parameterDict setObject:size forKey:@"size"];
    }
    
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:STwitterRequestMethodPOST];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:[request signedURLRequest] delegate:self];
    self.getUserProfileImageURLConnection = connection;
    
    if (getUserProfileImageURLConnection)
    {
        while (getUserProfileImageURLConnection && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
        
        if (getUserProfileImageResponse) {
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

- (NSURL *)getUserProfileImageURLWithUserID:(NSNumber *)userID size:(NSString *)size
{
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc] init];
    NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1/users/profile_image"]];
    
    // Make HTTP Body Dictionary and Data
    if (userID) {
        [parameterDict setObject:[userID stringValue] forKey:@"user_id"];
    }
    if (size) {
        [parameterDict setObject:size forKey:@"size"];
    }
    
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:STwitterRequestMethodPOST];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:[request signedURLRequest] delegate:self];
    self.getUserProfileImageURLConnection = connection;
    
    if (getUserProfileImageURLConnection)
    {
        while (getUserProfileImageURLConnection && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
        
        if (getUserProfileImageResponse) {
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
    
    if (connection == getUserProfileImageURLConnection) {
        [self.getUserProfileImageURLConnection cancel];
        self.getUserProfileImageURLConnection = nil;
    }
}

@end
