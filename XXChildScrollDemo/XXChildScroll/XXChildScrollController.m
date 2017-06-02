//
//  XXChildScrollController.m
//  XXChildScrollDemo
//
//  Created by HJTXX on 2017/4/11.
//  Copyright © 2017年 HJTXX. All rights reserved.
//

#import "XXChildScrollController.h"

#define XXSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define XXSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define XXNAVBAR_HEIGHT 44
#define XXSTATUSBAR_HEIGHT 20
#define XXVIEW_HEIGHT(view) view.bounds.size.height
#define XXVIEW_WIDTH(view) view.bounds.size.width

@interface XXChildScrollController () <UIScrollViewDelegate>

@end

@implementation XXChildScrollController

#pragma mark - Life cycle
- (instancetype)initWithChildControllers:(NSArray<UIViewController *> *)childControllers
                              startIndex:(NSInteger)startIndex {
    self = [super init];
    if(self) {
        self.childControllers = childControllers;
        if(startIndex >= 0 && startIndex < childControllers.count) {
            self.nowIndex = startIndex;
        } else {
            self.nowIndex = 0;
        }
        [self initBaseSetting];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutPageScrollView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //iOS7以后push，VC会自动偏移64，viewDidLoad和viewWillAppear中y仍是0，viewDidAppear才会变成64，故重新调整一次子控制器的frame
    [self resetChildViewControllerFrame];
}

#pragma mark - Layout
- (void)initBaseSetting {
    self.childTitleViewSize = CGSizeMake(XXSCREEN_WIDTH-150, XXNAVBAR_HEIGHT);
    self.gradientEnable = YES;
    
    //所有子控制器的初始展示状态
    for(NSInteger i=0; i<self.childControllers.count; i++) {
        [self.childLoadStates addObject:@(NO)];
    }
}

- (void)layoutPageScrollView {
    //初始化bodyView
    self.bodyScrollView.frame = CGRectMake(0, 0, XXSCREEN_WIDTH, XXVIEW_HEIGHT(self.view));
    self.bodyScrollView.contentSize = CGSizeMake(XXSCREEN_WIDTH*self.childControllers.count, 0);
    self.bodyScrollView.contentOffset = CGPointMake(XXSCREEN_WIDTH*self.nowIndex, 0);
    
    //初始化titleView
    self.titleScrollView.frame = CGRectMake(0, 0, self.childTitleViewSize.width, self.childTitleViewSize.height);
    self.titleScrollView.contentSize = CGSizeMake(self.childTitleViewSize.width*self.childControllers.count, 0);
    self.titleScrollView.contentOffset = CGPointMake(self.childTitleViewSize.width*self.nowIndex, 0);
    self.navigationItem.titleView = self.titleScrollView;
    
    //加载当前页及预加载左右页
    [self layoutChildBodyViewWithIndex:self.nowIndex];
    [self.view addSubview:self.bodyScrollView];
    
    [self scrollControllerDidEndChange];
}

/**
 加载指定子控制器的view
 */
- (void)layoutChildBodyViewWithIndex:(NSInteger)index {
    //在有效范围内且没有加载过
    if(index >= 0 && index < self.childControllers.count && ![self.childLoadStates[index] boolValue]) {
        //加载bodyView
        UIViewController *childController = self.childControllers[index];
        childController.view.frame = CGRectMake(XXSCREEN_WIDTH*index, 0, XXSCREEN_WIDTH, XXVIEW_HEIGHT(self.view));
        [self.bodyScrollView addSubview:childController.view];
        [self addChildViewController:childController];
        
        //加载titileView
        UIView *childTitleView = childController.navigationItem.titleView;
        childTitleView.frame = CGRectMake(self.childTitleViewSize.width*index, 0, self.childTitleViewSize.width, self.childTitleViewSize.height);
        [self.titleScrollView addSubview:childTitleView];
        
        //修改状态为已加载
        self.childLoadStates[index] = @(YES);
    }
}

/**
 移除历史child，保持内存占用

 @param index 索引
 */
- (void)removeHistoryChildWithIndex:(NSInteger)index {
    if(index >= 0 && index < self.childControllers.count && [self.childLoadStates[index] boolValue]) {
        //加载bodyView
        UIViewController *childController = self.childControllers[index];
        [childController.view removeFromSuperview];
        [childController removeFromParentViewController];
        
        //加载titileView
        UIView *childTitleView = childController.navigationItem.titleView;
        [childTitleView removeFromSuperview];
        
        //修改状态为已加载
        self.childLoadStates[index] = @(NO);
    }
}

/**
 重新设置一次ChildViewController的frame
 */
- (void)resetChildViewControllerFrame {
    for(UIViewController *childController in self.childViewControllers) {
        NSInteger index = [self.childControllers indexOfObject:childController];
        childController.view.frame = CGRectMake(XXSCREEN_WIDTH*index, 0, XXSCREEN_WIDTH, XXVIEW_HEIGHT(self.view));
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //联动body和title
    CGFloat relativeLocation = self.bodyScrollView.contentOffset.x/XXVIEW_WIDTH(self.bodyScrollView);
    self.titleScrollView.contentOffset = CGPointMake(self.childTitleViewSize.width*relativeLocation, 0);
    
    //title渐变
    if(self.gradientEnable) {
        NSInteger leftIndex = floor(relativeLocation);
        NSInteger rightIndex = leftIndex+1;
        
        if(leftIndex >= 0 && leftIndex < self.childControllers.count) {
            UIViewController *childController = self.childControllers[leftIndex];
            childController.navigationItem.titleView.alpha = 1-(relativeLocation-leftIndex)*2;
        }
        
        if(rightIndex >= 0 && rightIndex < self.childControllers.count) {
            UIViewController *childController = self.childControllers[rightIndex];
            childController.navigationItem.titleView.alpha = 1-(rightIndex-relativeLocation)*2;
        }
    }
    
    //滑动过程中预加载
    NSInteger scrollIndex = round(relativeLocation);
    [self layoutChildBodyViewWithIndex:scrollIndex-1];
    [self layoutChildBodyViewWithIndex:scrollIndex];
    [self layoutChildBodyViewWithIndex:scrollIndex+1];
    //移除距离当前页更远的控制器
    [self removeHistoryChildWithIndex:scrollIndex+2];
    [self removeHistoryChildWithIndex:scrollIndex-2];
}

/*手指滑动会触发该方法，setContentOffset:animated:不会触发*/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self changeNowIndexDidEndScroll];
}

/*setContentOffset:animated:会触发该方法，手指滑动不会触发*/
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self changeNowIndexDidEndScroll];
}

#pragma mark - Private
- (void)changeNowIndexDidEndScroll {
    NSInteger nextIndex = self.bodyScrollView.contentOffset.x/XXVIEW_WIDTH(self.bodyScrollView);
    if(nextIndex != self.nowIndex) {
        [self scrollControllerWillEndChange];
        self.nowIndex = nextIndex;
        [self layoutChildBodyViewWithIndex:self.nowIndex];
        [self scrollControllerDidEndChange];
    }
}

#pragma mark - Override
/**
 滑动即将结束处理事件，此时nowIndex未改变（子类重写，对即将消失的页面进行业务处理）
 */
- (void)scrollControllerWillEndChange {
    
}

/**
 滑动结束后处理事件（子类重写，对当前显示的页面进行业务处理）
 */
- (void)scrollControllerDidEndChange {
    
}

#pragma mark - Public
/**
 滑动到上一个
 */
- (void)scrollToLastChildController {
    if(self.nowIndex > 0) {
        CGPoint lastContentOffset = CGPointMake(XXSCREEN_WIDTH*(self.nowIndex-1), self.bodyScrollView.contentOffset.y);
        [self.bodyScrollView setContentOffset:lastContentOffset animated:YES];
    }
}

/**
 滑动到下一个
 */
- (void)scrollToNextChildController {
    if(self.nowIndex < self.childControllers.count-1) {
        CGPoint nextContentOffset = CGPointMake(XXSCREEN_WIDTH*(self.nowIndex+1), self.bodyScrollView.contentOffset.y);
        [self.bodyScrollView setContentOffset:nextContentOffset animated:YES];
    }
}

#pragma mark - Getter/setter 
- (UIScrollView *)titleScrollView {
    if(!_titleScrollView) {
        _titleScrollView = [UIScrollView new];
        _titleScrollView.pagingEnabled = YES;
        _titleScrollView.showsVerticalScrollIndicator = NO;
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.scrollEnabled = NO;
    }
    return _titleScrollView;
}

- (UIScrollView *)bodyScrollView {
    if(!_bodyScrollView) {
        _bodyScrollView = [UIScrollView new];
        _bodyScrollView.pagingEnabled = YES;
        _bodyScrollView.delegate = self;
        _bodyScrollView.showsVerticalScrollIndicator = NO;
        _bodyScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _bodyScrollView;
}

- (NSArray *)childControllers {
    if(!_childControllers) {
        _childControllers = @[];
    }
    return _childControllers;
}

- (NSMutableArray *)childLoadStates {
    if(!_childLoadStates) {
        _childLoadStates = [NSMutableArray array];
    }
    return _childLoadStates;
}

@end
