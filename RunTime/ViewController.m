//
//  ViewController.m
//  RunTime
//
//  Created by Jney on 2017/7/27.
//  Copyright © 2017年 Jney. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor cyanColor];
    
    id obj = nil;
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    ///正常情况下setObject为nil时会崩溃
    ///给可变字典里面添加nil对象
    [dic setObject:obj forKey:@"test"];
    ///给可变数组里面添加nil对象
    [array addObject:obj];
    ///数组下标越界
    [array objectAtIndex:2];
}





@end
