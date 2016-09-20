//
//  SXNetworkTools.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/24.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.//

#import <AFNetworking/AFNetworking.h>

@interface SXNetworkTools : AFHTTPSessionManager

+ (instancetype)sharedNetworkTools;
+ (instancetype)sharedNetworkToolsWithoutBaseUrl;

@end
