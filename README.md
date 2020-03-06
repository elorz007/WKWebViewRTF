# When trying to load a .rtf file into a WKWebView from data, it doesn't work.

In the examples below we use data from file but in the real scenario the data doesn't come from a file and we cannot write it in disc because of security rules.


Doesn't work: treated as text, not as rtf
```
- (void)loadRTFData {
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"file" withExtension:@"rtf"];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    NSString *MIMEType = @"application/rtf";
    //MIMEType = @"text/rtf";
    NSString *encodingName = @"utf-8";
    [self.webView loadData:data MIMEType:MIMEType characterEncodingName:encodingName baseURL:fileURL];
}
```
![non working screenshot][./WKWebView830.png]


Doesn't work: "This file cannot be previewed, it might be corrupted or of an unknown file format"
This workaround works with .docx files as seen in https://forums.developer.apple.com/thread/109589 but it doesn't for .rtf
```
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
```
However, these work:
```
- (void)loadRTFRequest {
    NSURL *url = [NSURL URLWithString:@"https://file-examples.com/wp-content/uploads/2019/09/file-sample_100kB.rtf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}
```
```
- (void)loadRTFFile {
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"file" withExtension:@"rtf"];
    [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
}
```

![working screenshot][UIWebView803.png]
