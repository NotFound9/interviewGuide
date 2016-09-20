//
//  TTHeaderNews.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/29.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTHeaderNews.h"
#import <MJExtension.h>
@implementation TTHeaderNews
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"desc":@"description",
             };
}

@end
