//
//  NSString RFC3875.h
//  TweetBlast
//
//  Created by Sinoru on 11. 4. 1..
//  Copyright 2011 Sinoru. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (RFC3875PercentEscapes)
- (NSString *)stringByAddingRFC3875PercentEscapesUsingEncoding:(NSStringEncoding)encoding;
- (NSString *)stringByReplacingRFC3875PercentEscapesUsingEncoding:(NSStringEncoding)encoding;

@end

@implementation NSString (RFC3875PercentEscapes)
- (NSString *)stringByAddingRFC3875PercentEscapesUsingEncoding:(NSStringEncoding)encoding {
    CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(encoding);
    NSString *rfcEscaped = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?#[]", cfEncoding);
    return rfcEscaped;
}

- (NSString *)stringByReplacingRFC3875PercentEscapesUsingEncoding:(NSStringEncoding)encoding {
    CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(encoding);
    NSString *rfcDecoded = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, NULL, cfEncoding);
    return rfcDecoded;
}

@end