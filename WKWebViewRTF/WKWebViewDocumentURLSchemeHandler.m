//
//  WKWebViewDocumentURLSchemeHandler.m
//  SPCommon
//
//  Created by Mikel Elorz on 09.03.20.
//  Copyright © 2020 Virtual Solution AG. All rights reserved.
//

#import "WKWebViewDocumentURLSchemeHandler.h"

@implementation WKWebViewDocumentURLSchemeHandler

- (NSURL *)workaroundURL {
    // Important, the url extension must also have .rtf or else bad things also happen
    NSString *urlString = [NSString stringWithFormat:@"%@://file.rtf", [self workaroundScheme]];
    return [NSURL URLWithString:urlString];
}

- (NSString *)workaroundScheme {
    // Could be anything, chose something long enough that it will never appear in real links
    // Also, this can be changed in the future, no problem
    return @"WKWebViewDocumentURLSchemeHandler";
}

- (void)webView:(WKWebView *)webView startURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask {
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"file" withExtension:@"rtf"];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    NSURLResponse *workaroundResponse =
        [[NSURLResponse alloc] initWithURL:[self workaroundURL] MIMEType:@"application/rtf" expectedContentLength:data.length textEncodingName:@"utf-8"];
    // These three methods must be called and exactly in this order, if not an exception will be thrown
    [urlSchemeTask didReceiveResponse:workaroundResponse];
    [urlSchemeTask didReceiveData:data];
    [urlSchemeTask didFinish];
}

- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask {
    // Nothing to do because the start method doesn't do any async operation and thus the cancelation cannot come in the middle
}

@end
