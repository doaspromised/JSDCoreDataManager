//
//  ViewController.m
//  JSDCoreDataManager
//
//  Created by Abner on 2017/8/31.
//  Copyright © 2017年 姜守栋. All rights reserved.
//

#import "ViewController.h"
#import "JSDCoreDataManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSManagedObjectContext *moc = [[JSDCoreDataManager sharedManager] moc];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
