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
    NSURL *URL;
    ACAccount *account;
    NSDictionary *OAuthToken;
    NSDictionary *parameters;
    STwitterRequestMethod requestMethod;
    NSArray *multiPartDatas;
    NSArray *multiPartNames;
    NSArray *multiPartTypes;
}

@property (nonatomic, retain) ACAccount *account;

@property (nonatomic, retain) NSDictionary *OAuthToken;

@property (nonatomic, readonly) STwitterRequestMethod requestMethod;

@property (nonatomic, readonly) NSURL *URL;

@property (nonatomic, readonly) NSDictionary *parameters;

- (id)initWithURL:(NSURL *)url parameters:(NSDictionary *)parameters requestMethod:(STwitterRequestMethod)STwitterRequestMethod;

- (void)addMultiPartData:(NSData*)data withName:(NSString*)name type:(NSString*)type;

- (NSURLRequest *)signedURLRequest;

- (void)performRequestWithHandler:(STwitterRequestHandler)handler;

@end
