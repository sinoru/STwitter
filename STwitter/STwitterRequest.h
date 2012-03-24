//
//  STwitterRequest.h
//  STwitter
//
//  Created by 재홍 강 on 12. 2. 13..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

enum STwitterRequestMethod {
    STwitterRequestMethodGET,
    STwitterRequestMethodPOST,
    STwitterRequestMethodDELETE
};

typedef enum STwitterRequestMethod STwitterRequestMethod;

typedef void(^STwitterRequestHandler)(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error);

@interface STwitterRequest : NSObject {
    @private
    NSArray *multiPartDatas;
    NSArray *multiPartNames;
    NSArray *multiPartTypes;
}

/**
 * Optional account information used to authenticate the request. 
 */
@property (nonatomic, retain) ACAccount *account;

/**
 * Optional account information used to authenticate the request. If you don't want using ACAccount.
 * This should be a dictionary that include keys named "OAuthConsumerKey", "OAuthConsumerSecret", "OAuthAccessToken", 
 * "OAuthAccessTokenSecret" and NSString objects.
 */
@property (nonatomic, retain) NSDictionary *OAuthToken;

/**
 * The method to use for this request. (read-only)
 *
 */
@property (nonatomic, readonly) STwitterRequestMethod requestMethod;

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
