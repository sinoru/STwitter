//
//  STwitterUser.h
//  TweetBlast
//
//  Created by Sinoru on 11. 4. 5..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface STwitterUser : NSObject

- (NSDictionary *)getUserProfileImageAndURLWithScreenName:(NSString *)screenName size:(NSString *)size;
- (NSURL *)getUserProfileImageURLWithScreenName:(NSString *)screenName size:(NSString *)size;

@property (nonatomic, strong) NSURLResponse *getUserProfileImageResponse;
@property (nonatomic, strong) NSURLConnection *getUserProfileImageURLConnection;

@end
