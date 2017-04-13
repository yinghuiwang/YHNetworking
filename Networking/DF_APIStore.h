//
//  DF_APIStore.h
//  DouFuShop
//
//  Created by 王英辉 on 16/5/26.
//  Copyright © 2016年 王英辉. All rights reserved.
//

#import <Foundation/Foundation.h>


//
extern NSString * const kBeanpayUcenter;

//
extern NSString * const kBeanpayPublic;

//
extern NSString * const kAliPay;

extern NSString * const kLive;
/**
 请求类型
 */
typedef enum {
    kGET,
    kPOST
}kRequestType;


/**
 *  请求成功回调block
 *
 *  @param task           会话对象
 *  @param responseObject 请求对象
 */
typedef void(^success)(NSURLSessionDataTask *  task, id   responseObject);

/**
 *  请求失败回调block
 *
 *  @param task           会话对象
 *  @param error 请求对象
 */
typedef void(^failure)(NSURLSessionDataTask *  task, NSError *  error);

@interface DF_APIStore : NSObject

@property(nonatomic, strong) NSMutableDictionary *  serviceStorage;
/**
 *  请求
 *
 *  @param type       请求类型
 *  @param URLString  urlString
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failres    失败回调
 */
- (void)requestType:(kRequestType)type url:(NSString *  )URLString
         parameters:( NSMutableDictionary * )parameters success:(success )success failure:(failure )failres;

- (void)requestWithServiceId:(NSString * )ServiceId RequestType:(kRequestType)type url:(NSString *  )URLString
                  parameters:( NSMutableDictionary * )parameters success:(success )success failure:(failure )failres;

+ (instancetype)sharedAPIStore;

@end
