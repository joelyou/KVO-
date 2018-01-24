//
//  ViewController.m
//  KVO封装公开课
//
//  Created by 八点钟学院 on 2017/9/6.
//  Copyright © 2017年 八点钟学院. All rights reserved.
//

#import "ViewController.h"
#import "EOCNextViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.frame = CGRectMake(100.f, 100.f, 100.f, 100.f);
    [btn setTitle:@"Push" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}


- (void)btnAction {
    
    EOCNextViewController *nextViewController = [[EOCNextViewController alloc] init];
    [self.navigationController pushViewController:nextViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
