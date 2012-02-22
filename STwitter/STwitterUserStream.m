//
//  STwitterUserStream.m
//  TweetBlast
//
//  Created by Sinoru on 11. 4. 9..
//  Copyright 2011 Sinoru. All rights reserved.
//

#import "STwitterUserStream.h"

NSString *const TweetBlastUserStreamConnectionDidFail = @"TweetBlastUserStreamConnectionDidFail";

@implementation STwitterUserStream

@synthesize delegate;
@synthesize userStreamConnection;
@synthesize userStreamData;

- (void)startUserStreamingWithAccount:(ACAccount *)aAccount
{
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSURL *apiURL = [NSURL URLWithString:@"https://userstream.twitter.com/2/user.json"];
    
    // We don't want *all* the individual messages from the
	// SBJsonStreamParser, just the top-level objects. The stream
	// parser adapter exists for this purpose.
	adapter = [[SBJsonStreamParserAdapter alloc] init];
	
	// Set ourselves as the delegate, so we receive the messages
	// from the adapter.
	adapter.delegate = self;
	
	// Create a new stream parser..
	parser = [[SBJsonStreamParser alloc] init];
	
	// .. and set our adapter as its delegate.
	parser.delegate = adapter;
	
	// Normally it's an error if JSON is followed by anything but
	// whitespace. Setting this means that the parser will be
	// expecting the stream to contain multiple whitespace-separated
	// JSON documents.
	parser.supportMultipleDocuments = YES;
    
    account = aAccount;
    accountIdentifier = account.identifier;
    
    // Create Request
    TWRequest *request = [[TWRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:TWRequestMethodGET];
    request.account = account;
    
    self.userStreamConnection = [[NSURLConnection alloc] initWithRequest:[request signedURLRequest] delegate:self];
    
    if (userStreamConnection) {
        userStreamData = [[NSMutableData alloc] init];
    }
}

- (void)startUserStreamingWithAccountIdentifier:(NSString *)identifier OAuthConsumerKey:(NSString *)oAuthConsumerKey oAuthConsumerSecret:(NSString *)oAuthConsumerSecret oAuthAccessToken:(NSString *)oAuthAccessToken oAuthAccessTokenSecret:(NSString *)oAuthAccessTokenSecret
{
    NSString *oAuthNonce;
    NSString *oAuthTimestamp;
    NSString *oAuthArgumentString;
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    NSString *parameterString = nil;
    NSURL *apiURL = [NSURL URLWithString:@"https://userstream.twitter.com/2/user.json"];
    NSURL *requestURL;
    accountIdentifier = identifier;
    
    // Generate UUID for OAuth Nonce
    STwitterOAuthTool *sTwitterOAuthTool = [[STwitterOAuthTool alloc] init];
    oAuthNonce = [sTwitterOAuthTool generateUUID];
    
    // Generate Time Stamp
    oAuthTimestamp = [NSString stringWithFormat:@"%i" , [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] intValue]];
    
    // Make OAuth Arguemnt Dictionary
    NSMutableDictionary *oAuthArgumentDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:oAuthConsumerKey, @"oauth_consumer_key", oAuthNonce, @"oauth_nonce", @"HMAC-SHA1", @"oauth_signature_method", oAuthAccessToken, @"oauth_token", oAuthTimestamp, @"oauth_timestamp", @"1.0", @"oauth_version", nil];
    
    if ([parameterDict count]) {
        parameterString = [sTwitterOAuthTool generateHTTPBody:parameterDict];
    }
    
    // Generate and Add OAuthTokenSignature
    NSMutableDictionary *oAuthSignatureDict = [[NSMutableDictionary alloc] initWithDictionary:oAuthArgumentDict];
    [oAuthSignatureDict addEntriesFromDictionary:parameterDict];
    
    [oAuthArgumentDict setObject:[sTwitterOAuthTool generateOAuthSignature:oAuthSignatureDict httpMethod:@"GET" apiURL:apiURL oAuthConsumerSecret:oAuthConsumerSecret oAuthTokenSecret:oAuthAccessTokenSecret] forKey:@"oauth_signature"];
    
    // Generate HTTP Authorization Header String
    oAuthArgumentString = [sTwitterOAuthTool generateHTTPAuthorizationHeader:oAuthArgumentDict];
    
    // Create Request
    if (parameterString) {
        requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [apiURL absoluteString], parameterString]];
    }
    else {
        requestURL = apiURL;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
    
    // Set HTTP Method to POST
    [request setHTTPMethod:@"GET"];
    
    // Set HTTP Authorization Header to requestsParameter
    [request setValue:oAuthArgumentString forHTTPHeaderField:@"Authorization"];
    
    // We don't want *all* the individual messages from the
	// SBJsonStreamParser, just the top-level objects. The stream
	// parser adapter exists for this purpose.
	adapter = [[SBJsonStreamParserAdapter alloc] init];
	
	// Set ourselves as the delegate, so we receive the messages
	// from the adapter.
	adapter.delegate = self;
	
	// Create a new stream parser..
	parser = [[SBJsonStreamParser alloc] init];
	
	// .. and set our adapter as its delegate.
	parser.delegate = adapter;
	
	// Normally it's an error if JSON is followed by anything but
	// whitespace. Setting this means that the parser will be
	// expecting the stream to contain multiple whitespace-separated
	// JSON documents.
	parser.supportMultipleDocuments = YES;
    
    self.userStreamConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (userStreamConnection) {
        userStreamData = [[NSMutableData alloc] init];
    }
}

- (void)stopUserStreaming {
    if (userStreamConnection) {
        [userStreamConnection cancel];
        self.userStreamConnection = nil;
    }
}

#pragma mark SBJsonStreamParserAdapterDelegate methods

- (void)parser:(SBJsonStreamParser *)parser foundArray:(NSArray *)array {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [delegate accountIdentifier:accountIdentifier didReceiveUserStreamObject:array];
    });
}

- (void)parser:(SBJsonStreamParser *)parser foundObject:(NSDictionary *)dict {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [delegate accountIdentifier:accountIdentifier didReceiveUserStreamObject:dict];
    });
}

#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	//NSLog(@"Connection didReceiveData of length: %u", data.length);
	
	// Parse the new chunk of data. The parser will append it to
	// its internal buffer, then parse from where it left off in
	// the last chunk.
	SBJsonStreamParserStatus status = [parser parse:data];
	
	if (status == SBJsonStreamParserError) {
		NSLog(@"Parser error: %@", parser.error);
		
	} else if (status == SBJsonStreamParserWaitingForData) {
		//NSLog(@"Parser waiting for more data");
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    [delegate accountIdentifier:accountIdentifier didFailWithError:error];
}

@end