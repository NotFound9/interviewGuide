//
//  TTPictureComment.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/3.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTPictureComment.h"
#import <MJExtension.h>

@implementation TTPictureComment
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [self mj_encode:aCoder];
}
@end
