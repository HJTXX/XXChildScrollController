//
//  MainViewController.m
//  XXChildScrollDemo
//
//  Created by HJTXX on 2017/4/11.
//  Copyright © 2017年 HJTXX. All rights reserved.
//

#import "MainViewController.h"
#import "XXTempChildScrollController.h"
#import "TestViewController.h"

@interface MainViewController ()

@property(nonatomic, strong) XXChildScrollController *scrollVC;
@property(nonatomic, strong) UIButton *enterBtn;
@property(nonatomic, strong) UIButton *lastBtn;
@property(nonatomic, strong) UIButton *nextBtn;

@property(nonatomic, strong) NSArray *controllers;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.enterBtn.frame = CGRectMake(0, 0, 100, 30);
    self.enterBtn.center = self.view.center;
    [self.view addSubview:self.enterBtn];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Event reponse
- (void)enterChildScroll:(id)sender {
    //子控制器的titleview的size应该是一样的，这样才方便统一展示
    TestViewController *test1 = [[TestViewController alloc] initWithTitle:@"上证指数" url:[NSURL URLWithString:@"https://gupiao.baidu.com/stock/sh000001.html"]];
    TestViewController *test2 = [[TestViewController alloc] initWithTitle:@"深证成指" url:[NSURL URLWithString:@"https://gupiao.baidu.com/stock/sz399001.html"]];
    TestViewController *test3 = [[TestViewController alloc] initWithTitle:@"恒生指数" url:[NSURL URLWithString:@"https://gupiao.baidu.com/stock/hkHSI.html"]];
    TestViewController *test4 = [[TestViewController alloc] initWithTitle:@"沪深300" url:[NSURL URLWithString:@"https://gupiao.baidu.com/stock/sh000300.html"]];
    TestViewController *test5 = [[TestViewController alloc] initWithTitle:@"上证50" url:[NSURL URLWithString:@"https://gupiao.baidu.com/stock/sh000016.html"]];
    TestViewController *test6 = [[TestViewController alloc] initWithTitle:@"中证500" url:[NSURL URLWithString:@"https://gupiao.baidu.com/stock/sh000905.html"]];
    TestViewController *test7 = [[TestViewController alloc] initWithTitle:@"贵州茅台" url:[NSURL URLWithString:@"https://gupiao.baidu.com/stock/sh600519.html"]];
    TestViewController *test8 = [[TestViewController alloc] initWithTitle:@"浦发银行" url:[NSURL URLWithString:@"https://gupiao.baidu.com/stock/sh600000.html"]];
    TestViewController *test9 = [[TestViewController alloc] initWithTitle:@"招商银行" url:[NSURL URLWithString:@"https://gupiao.baidu.com/stock/sh600036.html"]];
    TestViewController *test10 = [[TestViewController alloc] initWithTitle:@"中国中车" url:[NSURL URLWithString:@"https://gupiao.baidu.com/stock/sh601766.html"]];
    self.controllers = @[test1, test2, test3, test4, test5, test6, test7, test8, test9, test10];
    
    
    _scrollVC = [[XXTempChildScrollController alloc] initWithChildControllers:self.controllers startIndex:4];
//    _scrollVC.gradientEnable = NO;
    [_scrollVC.view addSubview:self.lastBtn];
    [_scrollVC.view addSubview:self.nextBtn];
    [self.navigationController pushViewController:_scrollVC animated:YES];
    
    //切换按钮有的也放在导航栏标题两端，类似同花顺app，
    self.lastBtn.hidden = NO;
    self.nextBtn.hidden = NO;
}

- (void)goToLast:(id)sender {
    [_scrollVC scrollToLastChildController];
}

- (void)goToNext:(id)sender {
    [_scrollVC scrollToNextChildController];
}

#pragma mark - XXChildScrollControllerDelegate
- (void)scrollControllerDidEndChange:(NSInteger)nowIndex {
    //在这里对展示的controller进行刷新等操作
    NSLog(@"nowIndex:%d", (int)nowIndex);
    
    //正常使用时子控制器的数据请求逻辑不建议放在viewWillAppear，viewDidAppear或者viewDidLoad中，这样在快速滑动时，每经过一个新页面都会有请求消耗并且绘制，正确的姿势应该是在该代理方法中请求数据，这样资源消耗较小，也更流畅（如果child较少，追求更快速地页面数据展示，可以放在生命周期方法中）
    TestViewController *nowChild = self.controllers[nowIndex];
    [nowChild loadRequest];
    
    //或者可以在请求当前页的基础上，加载上下页数据，也会达到较快的展示效果，并且消耗没有那么大(注意判断数组越界)
//    TestViewController *lastChild = self.controllers[nowIndex-1];
//    [lastChild loadRequest];
//    TestViewController *nextChild = self.controllers[nowIndex+1];
//    [nextChild loadRequest];
    
    //处理按钮展示
    self.lastBtn.hidden = nowIndex <= 0?YES:NO;
    self.nextBtn.hidden = nowIndex >= self.controllers.count-1?YES:NO;
}

#pragma mark - Getter/setter
- (UIButton *)enterBtn {
    if(!_enterBtn) {
        _enterBtn = [UIButton new];
        [_enterBtn setTitle:@"Enter" forState:UIControlStateNormal];
        [_enterBtn addTarget:self action:@selector(enterChildScroll:) forControlEvents:UIControlEventTouchUpInside];
        _enterBtn.backgroundColor = [UIColor redColor];
    }
    return _enterBtn;
}

- (UIButton *)lastBtn {
    if(!_lastBtn) {
        _lastBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 600, 60, 40)];
        [_lastBtn setTitle:@"上一页" forState:UIControlStateNormal];
        [_lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_lastBtn addTarget:self action:@selector(goToLast:) forControlEvents:UIControlEventTouchUpInside];
        _lastBtn.backgroundColor = [UIColor redColor];
    }
    return _lastBtn;
}

- (UIButton *)nextBtn {
    if(!_nextBtn) {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 600, 60, 40)];
        [_nextBtn setTitle:@"下一页" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(goToNext:) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.backgroundColor = [UIColor redColor];
    }
    return _nextBtn;
}

@end
