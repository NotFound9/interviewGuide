//
//  TTJudgeNetworking.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/10.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTJudgeNetworking.h"
#import "Reachability.h"

@implementation TTJudgeNetworking

+ (BOOL)judge {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        return NO;
    }
    return YES;
}

+(NetworkingType)currentNetworkingType {
    Reachability *reachablility =  [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([reachablility currentReachabilityStatus] == ReachableViaWiFi) {
        return NetworkingTypeWiFi;
    } else if ([reachablility currentReachabilityStatus] == ReachableViaWWAN) {
        return NetworkingType3G;
    }
    return NetworkingTypeNoReachable;
}
@end
