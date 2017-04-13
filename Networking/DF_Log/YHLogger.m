//
//  YHLogger.m
//  DouFuShop
//
//  Created by 王英辉 on 16/5/26.
//  Copyright © 2016年 王英辉. All rights reserved.
//

#import "YHLogger.h"

#import "NSMutableString+AXNetworkingMethods.h"

@interface YHLogger ()


@end

static BOOL showLog = YES;
@implementation YHLogger

+ (void)logDebugStartWithUrl:(NSURL *)url
{
#ifdef DEBUG
    if(!showLog)return;
    
    NSLog(@"\n==================================\n\nRequest Start: \n\n %@\n\n==================================", url);
    
#endif
}
+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName requestParams:(id)requestParams httpMethod:(NSString *)httpMethod
{
#ifdef DEBUG
    
    if(!showLog)return;
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                       Request Start                        *\n**************************************************************\n\n"];
    
    [logString appendFormat:@"API Name:\t\t%@\n", apiName];
    [logString appendFormat:@"Method:\t\t\t%@\n", httpMethod];

    [logString appendFormat:@"Params:\n%@", requestParams];
    
    [logString appendURLRequest:request];
    
    [logString appendFormat:@"\n\n**************************************************************\n*                         Request End                        *\n**************************************************************\n\n\n\n"];
    NSLog(@"%@", logString);
#endif
}

+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response responseString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error
{
#ifdef DEBUG
    
    if(!showLog)return;
    
    BOOL shouldLogError = error ? YES : NO;
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                        API Response                        =\n==============================================================\n\n"];
    
    [logString appendFormat:@"URL:\t%@\n\n", response.URL];
    [logString appendFormat:@"Status:\t%ld\t(%@)\n\n", (long)response.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]];
    [logString appendFormat:@"Content:\n\t%@\n\n", responseString];
    if (shouldLogError) {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
    }
    
    [logString appendString:@"\n---------------  Related Request Content  --------------\n"];
    
    [logString appendURLRequest:request];
    
    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n"];
    
    NSLog(@"%@", logString);
#endif
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static YHLogger *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


@end
