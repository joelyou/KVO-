//
//  EOCNextViewController.m
//  KVO的优雅封装
//
//  Created by 八点钟学院 on 2017/8/23.
//  Copyright © 2017年 八点钟学院. All rights reserved.
//

#import "EOCNextViewController.h"
//#import "NSObject+EOCKVO.h"
#import "NSObject+EOCNewKVO.h"

#import "Person.h"

@interface EOCNextViewController () {
    
//    Person *person;
    
}
@end

@implementation EOCNextViewController


/**
 1、addObserver
 2、observerForKeypath
 3、removeObserver
 
 
 NSObject分类里来实现： eocObserver:keypath:block
 

 
 */

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(100.f, 100.f, 100.f, 100.f);
    [btn setTitle:@"Pop" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    Person *person = [[Person alloc] init];
    
    [self eocObserver:person keyPath:@"name" block:^{
       
        NSLog(@"gooooood ->%@", person.name);
        
    }];
    
    [self eocObserver:person keyPath:@"age" block:^{
        NSLog(@"come here age!-> %@", person.age);
    }];
    
//    [person eocObserver:self keyPath:@"name" block:^{
//        
//        NSLog(@"goooood!");
//        
//    }];
    
    person.name = @"好好学习";
    person.age = @"12";
    
}

- (void)btnAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
