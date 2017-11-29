//
//  NSMutableDictionary+NilSafe.m
//  RunTime
//
//  Created by Jney on 2017/7/27.
//  Copyright © 2017年 Jney. All rights reserved.
//

#import <objc/runtime.h>
#import "NSMutableDictionary+NilSafe.h"

@implementation NSMutableDictionary (NilSafe)

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


+ (void)load {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        id obj = [[self alloc] init];
        
        [obj swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(safe_setObject:forKey:)];
        [obj swizzleMethod:@selector(setValue:forKey:) withMethod:@selector(safe_setValue:forKey:)];
        [obj swizzleMethod:@selector(removeObjectForKey:) withMethod:@selector(safe_removeObjectForKey:)];
       
        
    });
    
    
}


- (void)safe_setObject:(id)value forKey:(NSString *)key {
    
    if (value) {
        
        [self safe_setObject:value forKey:key];
        
    }else {
        
        NSLog(@"[NSMutableDictionary setObject: forKey:], Object cannot be nil");
        
    }
    
}

-(void)safe_setValue:(id)value forKey:(NSString *)key{
    
    if (value) {
        
        [self safe_setValue:value forKey:key];
        
    }else {
        
        NSLog(@"[NSMutableDictionary setValue: forKey:], Value cannot be nil");
        
    }
}

-(void)safe_removeObjectForKey:(id)aKey{
    
    if (!aKey) {
        NSLog(@"The Key of removeObjectForKey can not be nil");
    }else{
        [self safe_removeObjectForKey:aKey];
    }
    
}



@end

