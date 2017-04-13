//
//  ViewController.m
//  YHNetworking
//
//  Created by 王英辉 on 2017/4/13.
//  Copyright © 2017年 王英辉. All rights reserved.
//

#import "ViewController.h"

#import "DF_APIStore.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
}

- (IBAction)requestAction:(id)sender {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"user"] = @"7f6254b8f81f84709228d6d419d488ac";
    
    [[DF_APIStore sharedAPIStore] requestType:kGET url:@"apistore/dhc/getalltemplate" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}


@end
