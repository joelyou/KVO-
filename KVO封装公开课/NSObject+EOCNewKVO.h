//
//  NSObject+EOCNewKVO.h
//  KVO封装公开课
//
//  Created by 八点钟学院 on 2017/9/6.
//  Copyright © 2017年 八点钟学院. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^kvoBlock)();
@interface NSObject (EOCNewKVO)

- (void)eocObserver:(NSObject *)object keyPath:(NSString *)keyPath block:(kvoBlock)block;

@end
