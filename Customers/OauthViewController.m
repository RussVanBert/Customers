//
//  OauthViewController.m
//  Customers
//
//  Created by Russell Van Bert on 6/12/2013.
//  Copyright (c) 2013 MYOB. All rights reserved.
//

#import "OauthViewController.h"
#import "Connection.h"

@interface OauthViewController ()
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation OauthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"OAuth";

    CGRect webViewRect = UIScreen.mainScreen.bounds;
    self.webView = [[UIWebView alloc] initWithFrame:webViewRect];
    
    self.webView.delegate = self; // for the UIWebViewDelegate
    
    [self.view addSubview:self.webView];
    
    NSString *urlPath = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=code&scope=CompanyFile", OAUTH_PATH, YOUR_API_KEY, REDIRECT_URI];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlPath]];
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if([request.URL.scheme isEqualToString:REDIRECT_SCHEME])
    {
        NSString *URLString = [[request URL] absoluteString];
		if ([URLString rangeOfString:@"code="].location != NSNotFound)
        {
            NSString *code = [[URLString componentsSeparatedByString:@"="] lastObject];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:code forKey:@"code"];
            [defaults synchronize];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"oauthCodeUpdated" object:nil userInfo:@{@"code":code}];
            [self.navigationController popViewControllerAnimated:YES];
        }
	}
    return YES;
}

@end
