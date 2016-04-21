//
//  TTPictureFetchDataParameter.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/10.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTPictureFetchDataParameter : NSObject
@property (nonatomic, copy) NSString *recentTime;//最新的picture的时间

@property (nonatomic, copy) NSString *remoteTime;//最晚的picture的时间

@property (nonatomic, copy) NSString *maxtime;

@property (nonatomic, assign) NSInteger page;
@end
