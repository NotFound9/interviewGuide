//
//  TTNetworkManager.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/8/11.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTNetworkManager.h"

@implementation TTNetworkManager
+(TTNetworkManager *)shareManager {
    static TTNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken ,^{
        manager = [[self alloc] init];
    });
    return manager;
}

+(TTNetworkManager *)otherManager {
    static TTNetworkManager *manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        NSString *apikey = @"8b72ce2839d6eea0869b4c2c60d2a449";
        [manager.requestSerializer setValue:apikey forHTTPHeaderField:@"apikey"];
    });
    return manager;
}
@end
