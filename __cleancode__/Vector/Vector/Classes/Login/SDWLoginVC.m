//
//  SDWLoginVC.m
//  Vector
//
//  Created by alex on 11/1/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
@import WebKit;

#import "SDWAppSettings.h"
#import "SDWLoginVC.h"

@interface SDWLoginVC () <WKNavigationDelegate>
@property (strong) IBOutlet WebView *webView;

@end

@implementation SDWLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.webView setResourceLoadDelegate:self];

}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {


}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {

    //navigationResponse.response

}


- (void)viewDidAppear {

    NSString *script = @"alert('Hello')";

    WKUserScript *scr = [[WKUserScript alloc]initWithSource:script injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];

    WKUserContentController *contr;
    [contr addUserScript:scr];



    NSString *urlString = [NSString stringWithFormat:@"https://trello.com/1/authorize?key=%@&name=Vector&expiration=never&response_type=token&callback_method=fragment&return_url=Vector://authorize",SharedSettings.appToken];
    NSURL *authURL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:authURL];



    [self.webView.mainFrame loadRequest:request];

}


- (void)updateToken {

   // SharedSettings.userToken = @"0eacb1b8f4ae6d6c415cec52459267aa885af5e33b4328347f3a7367e5b522be";

}

@end
