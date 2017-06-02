//
//  TestViewController.h
//  XXChildScrollDemo
//
//  Created by HJTXX on 2017/4/11.
//  Copyright © 2017年 HJTXX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController

- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url;
- (void)loadRequest;

@end
