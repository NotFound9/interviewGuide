//
//  TTNetworkManager.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/8/11.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface TTNetworkManager : AFHTTPSessionManager
+(TTNetworkManager *)shareManager;
+(TTNetworkManager *)otherManager;
@end
