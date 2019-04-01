//
//  SDWLoginVC.m
//  Lists
//
//  Created by alex on 11/1/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
@import WebKit;

#import "SDWAppSettings.h"
#import "SDWLoginVC.h"

@interface SDWLoginVC ()
@property (strong) IBOutlet WebView *webView;

@end

@implementation SDWLoginVC

- (void)viewDidAppear {

    NSString *urlString = [NSString stringWithFormat:@"https://trello.com/1/authorize?key=%@&name=Lists&expiration=never&response_type=token&scope=read,write&callback_method=fragment&return_url=Lists://authorize",SharedSettings.appToken];
    NSURL *authURL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:authURL];
    [self.webView.mainFrame loadRequest:request];
}


@end
