//
//  YHLogger
//  DouFuShop
//
//  Created by 王英辉 on 16/5/26.
//  Copyright © 2016年 王英辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHLogger : NSObject

+ (void)logDebugStartWithUrl:(NSURL *)url;

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName requestParams:(id)requestParams httpMethod:(NSString *)httpMethod;
+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response responseString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error;

+ (instancetype)sharedInstance;

@end
