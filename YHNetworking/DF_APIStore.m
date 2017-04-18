//
//  DF_APIStore.m
//  DouFuShop
//
//  Created by 王英辉 on 16/5/26.
//  Copyright © 2016年 王英辉. All rights reserved.
//

#import "DF_APIStore.h"

#import "AFNetworking.h"

#import "YHLogger.h"


// CDL API
NSString *_Nonnull const kBeanpayUcenter = @"kBeanpayUcenter";

// Google Map API
NSString * _Nonnull const kBeanpayPublic = @"kBeanpayPublic";

NSString * _Nonnull const kAliPay = @"kAliPay";

NSString * _Nonnull const kLive = @"kLive";


@interface DF_APIStore ()

//AFNetworking stuff
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation DF_APIStore

static DF_APIStore * _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}
+ (instancetype)sharedAPIStore
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)requestType:(kRequestType)type url:(NSString * )URLString
         parameters:(NSMutableDictionary *)parameters success:(success )success failure:(failure )failres{
    
    [self requestWithServiceId:kBeanpayUcenter RequestType:type url:URLString parameters:parameters success:success failure:failres];
}


- (void)requestWithServiceId:(NSString *)ServiceId RequestType:(kRequestType)type url:(NSString * )URLString
                    parameters:(NSMutableDictionary * )parameters success:(success )success failure:(failure )failres{
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    

    NSString *method = @"";
    switch (type) {
        case kGET:
        {
            method = @"GET";
        }
            break;
        case kPOST:
        {
            method = @"POST";
        }
            break;
            
        default:
            break;
    }

    
    NSString *baseUrl = [self existBaseUrlWithIdentifier:ServiceId];
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",baseUrl,URLString];

    NSMutableURLRequest *mutableRequest = [self.httpRequestSerializer requestWithMethod:method URLString:urlstr parameters:parameters error:NULL];
    [mutableRequest addValue:@"e414b75a50376388906270f10df35f3d" forHTTPHeaderField:@"apikey"];
    mutableRequest.timeoutInterval = 10; // 超时时间

    [YHLogger logDebugInfoWithRequest:mutableRequest apiName:urlstr requestParams:parameters httpMethod:method];
    
    
    [YHLogger logDebugStartWithUrl:mutableRequest.URL];
    
    // 跑到这里的block的时候，就已经是主线程了。
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:mutableRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSData *responseData = responseObject;
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        if (error) {
            [YHLogger logDebugInfoWithResponse:httpResponse
                                responseString:responseString
                                       request:mutableRequest
                                         error:error];
            
             [self requestFailure:failres task:dataTask error:error];
          
        } else {
            // 检查http response是否成立。
            [YHLogger logDebugInfoWithResponse:httpResponse
                                responseString:responseString
                                       request:mutableRequest
                                         error:NULL];
            
            [self requestSuccess:success task:dataTask responseObject:responseObject];
            
        }
    }];
    

    [dataTask resume];
}

#pragma mark - public methods
- (NSString *)existBaseUrlWithIdentifier:(NSString *)identifier
{
    
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self baseUrlWithIdentifier:identifier];
    }
    NSString *baseUrl = self.serviceStorage[identifier];
//    if (kDidLogin) {
//        [Manager.requestSerializer setValue:[DF_UserInfo sharedDF_UserInfo].token forHTTPHeaderField:@"token"];
//    }
    return baseUrl;
}

#pragma mark - private methods
- (NSString *)baseUrlWithIdentifier:(NSString *)identifier
{
    // 注意: baseURL一定要以/结尾
    NSString *baseUrl = nil;
    
    // 总的接口
    if ([identifier isEqualToString:kBeanpayUcenter]) {
        baseUrl = @"http://apis.baidu.com/";
    }
    
    // 短信服务
    if ([identifier isEqualToString:kBeanpayPublic]) {
        baseUrl = @"短信接口域名";
    }
    
    // 支付回调服务
    if ([identifier isEqualToString:kAliPay]) {
        baseUrl = @"支付回调服务域名";
    }
    
    // 直播服务
    if ([identifier isEqualToString:kLive]) {
        baseUrl = @"支付域名";
    }
    
    return baseUrl;

}


- (void)requestSuccess:(success _Nullable)success task:(NSURLSessionDataTask * _Nonnull) task responseObject:(id  _Nullable) responseObject
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    MyLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    
    responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    
    if ([[responseObject objectForKey:@"code"] integerValue] == 499) {
        if (success) {
            success(task,nil);
        }
        return;
    }
    if (success) {
        success(task,responseObject);
    }
}

- (void)requestFailure:(failure _Nullable)failres task:(NSURLSessionDataTask * _Nullable) task  error:(NSError * _Nonnull) error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
        
    if (failres) {
        failres(task,error);
    }
}



#pragma mark - getters and setters
- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = 10;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
  
//        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
//        response.removesKeysWithNullValues = YES;
//        _sessionManager.responseSerializer = response;
        
        // 安全设置
        // 允许载入无效证书
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        // 不检查域名
        _sessionManager.securityPolicy.validatesDomainName = NO;
        
    }
    return _sessionManager;
}


@end
