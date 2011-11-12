//
//  NSString (HTMLEscape).h
//  TweetBlast
//
//  Created by Sinoru on 11. 4. 10..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (AmpersandEscapes)
- (NSString *)stringByAddingAmpersandEscapes;
- (NSString *)stringByReplacingAmpersandEscapes;

@end

@implementation NSString (AmpersandEscapes)
- (NSString *)stringByAddingAmpersandEscapes {
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    
    [mutableString replaceOccurrencesOfString:@"&"  withString:@"&amp;"  options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"'" withString:@"&#x27;"  options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"'" withString:@"&#x39;"  options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"'" withString:@"&#x92;"  options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"'" withString:@"&#x96;"  options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@">"   withString:@"&gt;"  options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"<"   withString:@"&lt;"  options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    
    return mutableString;
}

- (NSString *)stringByReplacingAmpersandEscapes {
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    
    [mutableString replaceOccurrencesOfString:@"&amp;"  withString:@"&"  options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"&#x27;" withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"&#x39;" withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"&#x92;" withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"&#x96;" withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"&gt;"   withString:@">"  options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"&lt;"   withString:@"<"  options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    
    return mutableString;
}

@end