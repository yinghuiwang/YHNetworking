//
//  NSObject+AXNetworkingMethods.m
//  DouFuShop
//
//  Created by 王英辉 on 16/5/26.
//  Copyright © 2016年 王英辉. All rights reserved.
//

#import "NSObject+AXNetworkingMethods.h"

@implementation NSObject (AXNetworkingMethods)

- (id)CT_defaultValue:(id)defaultData
{
    if (![defaultData isKindOfClass:[self class]]) {
        return defaultData;
    }
    
    if ([self CT_isEmptyObject]) {
        return defaultData;
    }
    
    return self;
}

- (BOOL)CT_isEmptyObject
{
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *)self length] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    
    return NO;
}

@end
