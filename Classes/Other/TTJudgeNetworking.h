//
//  TTJudgeNetworking.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/10.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TTJudgeNetworking : NSObject

typedef NS_ENUM(NSUInteger, NetworkingType) {
    NetworkingTypeNoReachable = 1,
    NetworkingType3G = 2,
    NetworkingTypeWiFi = 3,
};

+ (BOOL)judge;

+ (NetworkingType)currentNetworkingType;
@end
