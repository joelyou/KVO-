//
//  NSObject+EOCNewKVO.m
//  KVO封装公开课
//
//  Created by 八点钟学院 on 2017/9/6.
//  Copyright © 2017年 八点钟学院. All rights reserved.
//

#import "NSObject+EOCNewKVO.h"
#import <objc/runtime.h>

typedef void(^deallocBlock)();
@interface EOCKVOController : NSObject

@property(nonatomic, strong)NSObject *observedObject;
@property(nonatomic, strong)NSMutableArray <deallocBlock>*blockArr;

@end

@implementation EOCKVOController

-(NSMutableArray<deallocBlock> *)blockArr {
    
    if (!_blockArr) {
        _blockArr = [NSMutableArray array];
    }
    return _blockArr;
    
}


//nextviewController -> kvoController
- (void)dealloc {
    
    ///对observedObject  removeObserver
    NSLog(@"kvoController dealloc");
    [_blockArr enumerateObjectsUsingBlock:^(deallocBlock  _Nonnull block, NSUInteger idx, BOOL * _Nonnull stop) {
       
        block();
        
    }];
    
}

@end

@interface NSObject ()

@property(nonatomic, strong)NSMutableDictionary <NSString *, kvoBlock>*dict;
@property(nonatomic, strong)EOCKVOController *kvoController;

@end

@implementation NSObject (EOCNewKVO)

- (void)eocObserver:(NSObject *)object keyPath:(NSString *)keyPath block:(kvoBlock)block {
    
    self.dict[keyPath] = block;
    
    ///self已经持有了kvoController
    self.kvoController.observedObject = object;
    
    __unsafe_unretained typeof(self)weakSelf = self;
    
    [self.kvoController.blockArr addObject:^{
       
        [object removeObserver:weakSelf forKeyPath:keyPath];
        
    }];
    
    //监听
    [object addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    kvoBlock block = self.dict[keyPath];
    if (block) {
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

- (EOCKVOController *)kvoController {
    
    EOCKVOController *tmpKvoController = objc_getAssociatedObject(self, @selector(kvoController));
    if (!tmpKvoController) {
        
        tmpKvoController = [[EOCKVOController alloc] init];
        objc_setAssociatedObject(self, @selector(kvoController), tmpKvoController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    return tmpKvoController;
    
}
@end
