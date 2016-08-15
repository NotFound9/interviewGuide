//
//  TTNetworkManager.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/8/11.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Completion)(NSURLSessionDataTask *task ,NSDictionary *responseObject);
typedef void (^Failure)(NSError *error);

@interface TTNetworkManager : NSObject

+(TTNetworkManager *)shareManager;

/**
 *  有请求头的get请求
 */
-(void)Get:(NSString *)url Parameters:(NSDictionary *)parameters Success:(Completion)success Failure:(Failure)failure;

/**
 *  有请求头的get请求
 */
-(void)Get2:(NSString *)url Parameters:(NSDictionary *)parameters Success:(Completion)success Failure:(Failure)failure;

@end
