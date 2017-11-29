//
//  NSMutableArray+NilSafe.m
//  RunTime
//
//  Created by Jney on 2017/7/27.
//  Copyright © 2017年 Jney. All rights reserved.
//

#import "NSMutableArray+NilSafe.h"
#import <objc/runtime.h>

@implementation NSMutableArray (NilSafe)

+ (void) load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id obj = [[self alloc] init];
        ///动态运行时校验两个方法
        [obj swizzleMethod:@selector(addObject:) withMethod:@selector(safe_addObject:)];
        [obj swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safe_objectAtIndex:)];
        [obj swizzleMethod:@selector(setObject:atIndexedSubscript:) withMethod:@selector(safe_setObject:atIndexedSubscript:)];
        [obj swizzleMethod:@selector(removeObject:) withMethod:@selector(safe_removeObject:)];
        [obj swizzleMethod:@selector(removeObjectAtIndex:) withMethod:@selector(safe_removeObjectAtIndex:)];
        [obj swizzleMethod:@selector(insertObject:atIndex:) withMethod:@selector(safe_insertObject:atIndex:)];
    });
    
}


- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector{
    
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
    
    /**
     动态运行时给类添加方法
     
     @param class 需要添加方法的类
     @param origSelector 方法名
     @param swizzledMethod IMP 实现这个方法的函数
     @return 表示添加方法成功与否
     */
    BOOL didAddMethod = class_addMethod(class,
                                        origSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        
        class_replaceMethod(class,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

-(void)safe_removeObject:(id)anObject{
    
    if (!anObject) {
        NSLog(@"remove object can not be nil");
    }else{
        [self safe_removeObject:anObject];
    }

}

-(void)safe_removeObjectAtIndex:(NSUInteger)index{
    
    if (index > self.count) {
        NSLog(@"数组下标越界");
    }else{
        [self safe_removeObjectAtIndex:index];
    }
    
}

- (void)safe_addObject:(id)value{
    
    if (value) {
        [self safe_addObject:value];
    }else {
        ///这里是设置obj为nil的时候进入
        NSLog(@"[NSMutableArray addObject:], Object cannot be nil");
    }
    
}

- (id)safe_objectAtIndex:(NSInteger)index{
    
    if (index < self.count) {
        
        return [self safe_objectAtIndex:index];
        
    }else {
        ///下标越界
        NSLog(@"数组下标越界");
        return nil;
        
    }
    
}

-(void)safe_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx{
    
    if (!obj || (idx > self.count)) {
        NSLog(@"数组下标越界,obj为nil");
    }else{
        [self safe_setObject:obj atIndexedSubscript:idx];
    }
}

-(void)safe_removeObjectsInRange:(NSRange)range{
    
    if (range.location == self.count) {
        NSLog(@"数组下标越界");
    }else{
        [self safe_removeObjectsInRange:range];
    }
}

-(void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index{
    
    if (!anObject) {
        NSLog(@"insertObject object can not be nil");
    }else{
        [self safe_insertObject:anObject atIndex:index];
    }
}

@end
