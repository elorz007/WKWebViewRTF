//
//  ViewController.m
//  WKWebViewRTF
//
//  Created by Mikel Elorz on 06.03.20.
//  Copyright © 2020 Mikel Elorz. All rights reserved.
//

#import "ViewController.h"
@import  WebKit;

@interface ViewController () <WKNavigationDelegate>
@property (nonatomic, weak) IBOutlet WKWebView *webView;
@property (nonatomic, assign) BOOL performHackyReloadWorkaround;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.navigationDelegate = self;
    
    self.performHackyReloadWorkaround = YES;
    
    // Doesn't work: treated as text, not as rtf
    [self loadRTFData];
    
    // Doesn't work: treated as text, not as rtf
    //[self loadRTFDataTask];
    
    // Doesn't work: "This file cannot be previewed, it might be corrupted or of an unknown file format"
    // This workaround works with .docx files as seen in https://forums.developer.apple.com/thread/109589 but it doesn't for .rtf
    //[self loadRTFInlineDataURL];
    
    // Works:
    //[self loadRTFRequest];
    
    // Works:
    //[self loadRTFFile];
}

- (void)loadRTFData {
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"file" withExtension:@"rtf"];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    NSString *MIMEType = @"application/rtf";
    //MIMEType = @"text/rtf";
    NSString *encodingName = @"utf-8";
    [self.webView loadData:data MIMEType:MIMEType characterEncodingName:encodingName baseURL:fileURL];
}

- (void)loadRTFInlineDataURL {
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"file" withExtension:@"rtf"];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    NSString *base64Data = [data base64EncodedStringWithOptions:kNilOptions];
    NSString *MIMEType = @"application/rtf";
    //MIMEType = @"text/rtf";
    NSString *urlString = [NSString stringWithFormat:@"data:%@;base64,%@", MIMEType, base64Data];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)loadRTFFile {
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"file" withExtension:@"rtf"];
    [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
}

- (void)loadRTFRequest {
    NSURL *url = [NSURL URLWithString:@"https://file-examples.com/wp-content/uploads/2019/09/file-sample_100kB.rtf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    /*
     Response
     HTTP/1.1 200 OK
     Content-Type: application/rtf
     Content-Length: 100605
     Last-Modified: Sat, 21 Sep 2019 12:13:44 GMT
     Cache-Control: max-age=0
     ETag: "188fd-5930f1e3e5df2"
     Accept-Ranges: bytes
     Date: Fri, 06 Mar 2020 14:25:33 GMT
     Keep-Alive: timeout=5, max=100
     Expires: Fri, 06 Mar 2020 14:25:33 GMT
     Connection: Keep-Alive
     Server: Apache/2.4.10
     */
}

- (void)loadRTFDataTask {
    NSURL *url = [NSURL URLWithString:@"https://file-examples.com/wp-content/uploads/2019/09/file-sample_100kB.rtf"];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    [[session dataTaskWithURL:url
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // response.MIMEType = application/rtf
            // response.textEncodingName = nil
            [self.webView loadData:data MIMEType:response.MIMEType characterEncodingName:response.textEncodingName baseURL:url];
        });
    }] resume];
}


//MARK: - WKNavigationDelegate

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.performHackyReloadWorkaround) {
        [self.webView reload];
    }
}

@end
