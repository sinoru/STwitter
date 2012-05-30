//
//  STwitterRequest.h
//  STwitter
//
//  Created by Sinoru on 12. 2. 13..
//  Copyright (c) 2012년 Sinoru. All rights reserved.
//

#import <Foundation/Foundation.h>

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0)
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#elif (__MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_10_8)
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#endif

extern NSString* const kOAuthConsumerKey;
extern NSString* const kOAuthConsumerSecret;
extern NSString* const kOAuthToken;
extern NSString* const kOAuthTokenSecret;

enum STwitterRequestMethod {
    STwitterRequestMethodGET,
    STwitterRequestMethodPOST,
    STwitterRequestMethodDELETE
};

enum STwitterRequestCompressionType {
	STwitterRequestCompressionNone,
	STwitterRequestCompressionGzip,
};

typedef enum STwitterRequestMethod STwitterRequestMethod;

typedef enum STwitterRequestCompressionType STwitterRequestCompressionType;

typedef void(^STwitterRequestHandler)(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error);

@interface STwitterRequest : NSObject

/**
 * Optional account information used to authenticate the request. 
 */
@property (nonatomic, retain) ACAccount *account __OSX_AVAILABLE_STARTING(__MAC_10_8,__IPHONE_5_0);

/**
 * Optional account information used to authenticate the request. If you don't want using ACAccount.
 * This should be a dictionary that include keys named "OAuthConsumerKey", "OAuthConsumerSecret", "OAuthToken", 
 * "OAuthTokenSecret" and NSString objects.
 */
@property (nonatomic, retain) NSDictionary *OAuthToken;

/**
 * The method to use for this request. (read-only)
 *
 */
@property (nonatomic, readonly) STwitterRequestMethod requestMethod;

/**
 * The compression type to use for this request.
 *
 * The default value of this property is STwitterRequestCompressionTypeNone.
 */
@property (nonatomic) STwitterRequestCompressionType requestCompressionType;

/**
 * The destination URL for this request. (read-only)
 */
@property (nonatomic, readonly) NSURL *URL;

/**
 * The parameters for this request. (read-only)
 */
@property (nonatomic, readonly) NSDictionary *parameters;


/**
 * Initializes a newly created request object with the specified properties.
 *
 * @param The destination URL for this HTTP request.
 * @param The parameters for this HTTP request.
 * @param The method to use for this HTTP request.
 * @return The newly initialized request object.
 */
- (id)initWithURL:(NSURL *)url parameters:(NSDictionary *)parameters requestMethod:(STwitterRequestMethod)STwitterRequestMethod;

/**
 * Specifies a named multipart POST body for this request.
 *
 * @param The data for the multipart POST body.
 * @param The name of the multipart POST body.
 * @param The type of the multipart POST body.
 */
- (void)addMultiPartData:(NSData*)data withName:(NSString*)name type:(NSString*)type;

/**
 * Returns an authorized request that can be sent using an NSURLConnection object.
 *
 * @return An OAuth-compatible NSURLRequest object that allows an application to act on behalf of the user while keeping 
 * the user’s password private.
 */
- (NSURLRequest *)signedURLRequest;

/**
 * Performs the request and calls the specified handler when done.
 *
 * @param The handler to call when the request is done. 
 */
- (void)performRequestWithHandler:(STwitterRequestHandler)handler;

@end
