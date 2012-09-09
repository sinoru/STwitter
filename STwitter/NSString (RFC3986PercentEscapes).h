//
//  NSString RFC3986.h
//  STwitter
//
//  Created by Sinoru on 11. 4. 1..
//  Copyright 2011 Sinoru. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (RFC3986PercentEscapes)
- (NSString *)stringByAddingRFC3986PercentEscapesUsingEncoding:(NSStringEncoding)encoding;
- (NSString *)stringByReplacingRFC3986PercentEscapesUsingEncoding:(NSStringEncoding)encoding;

@end

@implementation NSString (RFC3986PercentEscapes)
- (NSString *)stringByAddingRFC3986PercentEscapesUsingEncoding:(NSStringEncoding)encoding {
    CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(encoding);
    CFStringRef rfcEscapedString =
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, CFSTR(":/?#[]@!$&’()*+,;="), cfEncoding);
    
    return (__bridge_transfer NSString *)rfcEscapedString;
}

- (NSString *)stringByReplacingRFC3986PercentEscapesUsingEncoding:(NSStringEncoding)encoding {
    CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(encoding);
    CFStringRef rfcDecodedString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (__bridge CFStringRef)self, CFSTR(""), cfEncoding);
    
    return (__bridge_transfer NSString *)rfcDecodedString;
}

@end