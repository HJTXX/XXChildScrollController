//
//  XXTempChildScrollController.m
//  XXChildScrollDemo
//
//  Created by HJTXX on 2017/6/2.
//  Copyright © 2017年 HJTXX. All rights reserved.
//

#import "XXTempChildScrollController.h"
#import "TestViewController.h"

@interface XXTempChildScrollController ()

@end

@implementation XXTempChildScrollController

/**
 滑动即将结束处理事件，此时nowIndex未改变（子类重写，对即将消失的页面进行业务处理）
 */
- (void)scrollControllerWillEndChange {
    //此时取消当前页的操作，以我自己产品为例，会取消当前页的socket推送
}

/**
 滑动结束后处理事件（子类重写，对当前显示的页面进行业务处理）
 */
- (void)scrollControllerDidEndChange {
    //对将显示的页进行操作，例如请求加载
    TestViewController *detailVC = self.childControllers[self.nowIndex];
    [detailVC loadRequest];
}

@end
