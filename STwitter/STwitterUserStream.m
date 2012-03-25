//
//  STwitterUserStream.m
//  STwitter
//
//  Created by Sinoru on 11. 4. 9..
//  Copyright 2011 Sinoru. All rights reserved.
//

#import "STwitterUserStream.h"
#import "STwitterRequest.h"
#import "STwitterOAuthTool.h"
#import "SBJson/SBJson.h"

NSString *const TweetBlastUserStreamConnectionDidFail = @"TweetBlastUserStreamConnectionDidFail";

@interface STwitterUserStream () <NSURLConnectionDelegate, SBJsonStreamParserAdapterDelegate>

@property (nonatomic) SBJsonStreamParser *parser;
@property (nonatomic) SBJsonStreamParserAdapter *adapter;

@end

@implementation STwitterUserStream

@synthesize accountIdentifier;
@synthesize delegate;
@synthesize userStreamConnection;
@synthesize userStreamData;
@synthesize parser;
@synthesize adapter;

- (void)startUserStreamingWithAccount:(ACAccount *)account
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
    
    accountIdentifier = identifier;
    
    // Create Request
    STwitterRequest *request = [[STwitterRequest alloc] initWithURL:apiURL parameters:parameterDict requestMethod:STwitterRequestMethodGET];
    request.OAuthToken = [[NSDictionary alloc] initWithObjectsAndKeys:oAuthConsumerKey, @"OAuthConsumerKey", oAuthConsumerSecret, @"OAuthConsumerSecret", oAuthAccessToken, @"OAuthAccessToken", oAuthAccessTokenSecret, @"OAuthAccessTokenSecret", nil];
    
    self.userStreamConnection = [[NSURLConnection alloc] initWithRequest:[request signedURLRequest] delegate:self];
    
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