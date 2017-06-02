//
//  TestViewController.m
//  XXChildScrollDemo
//
//  Created by HJTXX on 2017/4/11.
//  Copyright © 2017年 HJTXX. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@property(nonatomic, strong) UIView *titleView;
@property(nonatomic, strong) UILabel *titleLbl;
@property(nonatomic, strong) UIWebView *webView;

@property(nonatomic, strong) NSString *titleStr;
@property(nonatomic, strong) NSURL *url;

@end

@implementation TestViewController

- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url {
    self = [super init];
    if(self) {
        _titleStr = title;
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.titleView addSubview:self.titleLbl];
    self.titleLbl.center = self.titleView.center;
    self.navigationItem.titleView = self.titleView;
    
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadRequest];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)loadRequest {
    [self.webView loadRequest:[NSURLRequest requestWithURL:_url]];
}

#pragma mark - Getter/setter
- (UIView *)titleView {
    if(!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-150, 44)];
    }
    return _titleView;
}

- (UILabel *)titleLbl {
    if(!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        _titleLbl.textColor = [UIColor blackColor];
        _titleLbl.text = _titleStr;
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}

- (UIWebView *)webView {
    if(!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    }
    return _webView;
}

@end
