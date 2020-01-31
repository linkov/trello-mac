//
//  SDWLoginVC.m
//  Lists
//
//  Created by alex on 11/1/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
@import WebKit;



@interface SDWListsSchemeHandler : NSObject <WKURLSchemeHandler>

@end


@implementation SDWListsSchemeHandler

- (void)webView:(WKWebView *)webView startURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask {
    [[NSWorkspace sharedWorkspace] openURL: urlSchemeTask.request.URL];
}

- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask {
    
}

@end

#import "SDWAppSettings.h"
#import "SDWLoginVC.h"

@interface SDWLoginVC () <WKUIDelegate, WKNavigationDelegate>
@property (strong) WKWebView *webView;

@end

@implementation SDWLoginVC


- (void)viewDidLoad {
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    [configuration setURLSchemeHandler:[SDWListsSchemeHandler new] forURLScheme:@"lists"];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    self.webView.translatesAutoresizingMaskIntoConstraints = false;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
//    self.view = self.webView;
    [self.view addSubview:self.webView];


    NSDictionary *viewsDictionary = @{@"webView":self.webView};
    NSArray *constr1 = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[webView]-|" options: 0 metrics:nil views:viewsDictionary];
    NSArray *constr2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[webView]-|" options: 0 metrics:nil views:viewsDictionary];

    [self.view addConstraints:constr1];
    [self.view addConstraints:constr2];
    
}


- (void)reloadURL {
    NSString *urlString = [NSString stringWithFormat:@"https://trello.com/1/authorize?key=%@&name=Lists&expiration=never&response_type=token&scope=read,write&callback_method=fragment&return_url=Lists://authorize",SharedSettings.appToken];
    NSURL *authURL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:authURL];
    [self.webView loadRequest:request];
}

- (void)viewDidAppear {

    [self reloadURL];
}



- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {


    if ([navigationAction.request.URL.absoluteString isEqualToString:@"https://www.atlassian.com/legal/privacy-policy"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [[NSWorkspace sharedWorkspace] openURL:navigationAction.request.URL];
       [self reloadURL];

    } else {

        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {


    if (!navigationAction.targetFrame.isMainFrame) {
       [webView loadRequest:navigationAction.request];
     }

     return nil;
}


@end
