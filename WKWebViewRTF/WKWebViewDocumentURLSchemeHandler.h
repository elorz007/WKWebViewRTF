//
//  WKWebViewDocumentURLSchemeHandler.h
//  SPCommon
//
//  Created by Mikel Elorz on 09.03.20.
//  Copyright © 2020 Virtual Solution AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@import WebKit;
@class SPCDocumentModel;

NS_ASSUME_NONNULL_BEGIN

/**
 This class is used to "trick" WKWebView into thinking a document's data has been loaded by a URL request. This ensures that the document is treated properly and shown properly. This is introduced
 because WKWebView's loadData: method doesn't work for RTF documents.

 This class makes use of WKWebView custom scheme handler. We tell the WKWebView to handle one specific scheme, e.g. "customspimscheme", with an instance of this handler.
 WKWebViewConfiguration *configuration = ...
 [configuration setURLSchemeHandler:self.schemeHandler forURLScheme:@"customspimscheme"];

 Then when loading the data, instead of doing:
 [webView loadData:data MIMEType:MIMEType characterEncodingName:characterEncodingName baseURL:baseURL]
 a URL request has to be passed that uses that custom scheme
 [webView loadRequest:[NSURLRequest requestWithURL:[NSURL urlWithString:@"customspimscheme://file.rtf"]]];
 Then the WKWebView will call -webView:startURLSchemeTask: and the same data will be provided.

 To make things easier, this class takes care of building the custom scheme and the url with the custom scheme given a SPCDocumentModel instance.
 It also implements the -webView:startURLSchemeTask: to provide data, MIMEType, etc. from that document instance.
 */
@interface WKWebViewDocumentURLSchemeHandler : NSObject <WKURLSchemeHandler>

- (NSURL *)workaroundURL;
- (NSString *)workaroundScheme;

@end

NS_ASSUME_NONNULL_END
