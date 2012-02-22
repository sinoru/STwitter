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

@interface STwitterRequest : NSObject {
    @private
    NSURL *URL;
    ACAccount *account;
    NSDictionary *OAuthToken;
    NSDictionary *parameters;
    STwitterRequestMethod requestMethod;
}

@property (nonatomic, retain) ACAccount *account;

@property (nonatomic, retain) NSDictionary *OAuthToken;

@property (nonatomic, readonly) STwitterRequestMethod requestMethod;

@property (nonatomic, readonly) NSURL *URL;

@property (nonatomic, readonly) NSDictionary *parameters;

- (id)initWithURL:(NSURL *)url parameters:(NSDictionary *)parameters requestMethod:(STwitterRequestMethod)STwitterRequestMethod;

- (NSURLRequest *)signedURLRequest;

@end
