//
//  XXChildScrollController.h
//  XXChildScrollDemo
//
//  Created by HJTXX on 2017/4/11.
//  Copyright © 2017年 HJTXX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXChildScrollController : UIViewController

#pragma mark - Base
@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIScrollView *bodyScrollView;

@property (nonatomic, strong) NSArray *childControllers;
@property (nonatomic, strong) NSMutableArray *childLoadStates; //存储子控制器的加载状态，YES已加载，NO未加载
@property (nonatomic, assign) NSInteger nowIndex;

#pragma mark - Setting
/*childController的titleView的展示size，默认([UIScreen mainScreen].bounds.size.width-150, 44)*/
@property (nonatomic, assign) CGSize childTitleViewSize;
/*是否打开titleView渐变效果，默认YES*/
@property (nonatomic, assign) BOOL gradientEnable;

#pragma mark - Method
- (instancetype)initWithChildControllers:(NSArray<UIViewController *> *)childControllers
                              startIndex:(NSInteger)startIndex;
- (void)scrollToLastChildController;
- (void)scrollToNextChildController;

- (void)scrollControllerWillEndChange;
- (void)scrollControllerDidEndChange;

@end
