//
//  STwitterUser.h
//  TweetBlast
//
//  Created by Sinoru on 11. 4. 5..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface STwitterUser : NSObject {
    NSURLConnection *getUserProfileImageConnection;
    NSURLConnection *getUserProfileImageURLConnection;
    NSMutableData *getUserProfileImageActiveDownload;
    NSURLResponse *getUserProfileImageResponse;
    NSData *getUserProfileImageResult;
}

- (NSDictionary *)getUserProfileImageAndURLWithScreenName:(NSString *)screenName size:(NSString *)size;
- (NSURL *)getUserProfileImageURLWithScreenName:(NSString *)screenName size:(NSString *)size;

@property (nonatomic, strong) NSMutableData *getUserProfileImageActiveDownload;
@property (nonatomic, strong) NSURLResponse *getUserProfileImageResponse;
@property (nonatomic, strong) NSData *getUserProfileImageResult;
@property (nonatomic, strong) NSURLConnection *getUserProfileImageConnection;
@property (nonatomic, strong) NSURLConnection *getUserProfileImageURLConnection;

@end
