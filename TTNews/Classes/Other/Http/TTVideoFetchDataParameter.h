//
//  TTVideoFetchDataParameter.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/7.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTVideoFetchDataParameter : NSObject

@property (nonatomic, copy) NSString *recentTime;//最新的video的时间

@property (nonatomic, copy) NSString *remoteTime;//最晚的video的时间

@property (nonatomic, copy) NSString *maxtime;

@property (nonatomic, assign) NSInteger page;

@end
