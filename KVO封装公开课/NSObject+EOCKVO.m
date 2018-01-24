//
//  NSObject+EOCKVO.m
//  KVO封装公开课
//
//  Created by 八点钟学院 on 2017/9/6.
//  Copyright © 2017年 八点钟学院. All rights reserved.
//

#import "NSObject+EOCKVO.h"
#import <objc/runtime.h>

@interface NSObject ()

@property(nonatomic, strong)NSMutableDictionary <NSString *, kvoBlock>*dict;
@property(nonatomic, strong)NSMutableDictionary <NSString *, NSMutableArray *> *kvoDict;

@end

@implementation NSObject (EOCKVO)


- (void)eocObserver:(NSObject *)observer keyPath:(NSString *)keyPath block:(kvoBlock)block {
    
    observer.dict[keyPath] = block;
    
    ///一个keyPath是对应了多个observer，一个observer对应了多个keyPath
    NSMutableArray *arr = self.kvoDict[keyPath];
    if (!arr) {
        arr = [NSMutableArray array];
        self.kvoDict[keyPath] = arr;
    }
    
    [arr addObject:observer];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        method_exchangeImplementations(class_getInstanceMethod([self class], @selector(eocDealloc)), class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc")));

    });
    
    ///self是person  observer是nextViewCOntroller
    [self addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    ///dealloc的时候  self removeObserver:forkeyPath
    
    
}

- (void)eocDealloc {
    
    NSLog(@"eocDealloc");
    
    ///执行removeObserber
    if ([self isKVO]) {
    
        [self.kvoDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray * _Nonnull obj, BOOL * _Nonnull stop) {
            
            NSMutableArray *arr = self.kvoDict[key];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [self removeObserver:obj forKeyPath:key];
                
            }];
            
        }];
        
    }
    
    [self eocDealloc];
    
}

- (BOOL)isKVO {
    
    if (objc_getAssociatedObject(self, @selector(kvoDict))) {
        
        return YES;
        
    } else {
        
        return NO;
        
    }
    
}

//observer里来调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    ///执行block
    kvoBlock block = self.dict[keyPath];
    if(block) {
        
        block();
        
    }
    
    
}

////getter 和 setter方法
- (NSMutableDictionary<NSString *,kvoBlock> *)dict {
    
    NSMutableDictionary *tmpDict = objc_getAssociatedObject(self, @selector(dict));
    if (!tmpDict) {
        tmpDict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(dict), tmpDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tmpDict;
    
}

- (NSMutableDictionary<NSString *,NSMutableArray *> *)kvoDict {
    
    NSMutableDictionary *tmpDict = objc_getAssociatedObject(self, @selector(kvoDict));
    if (!tmpDict) {
        tmpDict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(kvoDict), tmpDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tmpDict;
    
}

@end
