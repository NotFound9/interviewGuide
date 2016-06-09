
//
//  NormalNews.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/24.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTNormalNews.h"

@implementation TTNormalNews

-(void)setPubDate:(NSString *)pubDate {
    _pubDate = pubDate;
    _createdtime = [[[pubDate stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""].integerValue;
}

-(void)setImageurls:(NSArray *)imageurls {
    _imageurls = imageurls;
    
    CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat horizontalMargin = 10;
    CGFloat verticalMargin = 15;
    CGFloat controlMargin = 5;
    CGFloat titleLabelHeight = 19.5;
    CGFloat descLabelHeight = 31;
    CGFloat commentLabelHeight = 13.5;
    
    if (imageurls.count>=3) {
        self.normalNewsType = NormalNewsTypeMultiPicture;
        self.cellHeight = verticalMargin + titleLabelHeight + horizontalMargin + ((kScreenWidth - 4 *horizontalMargin)/3)*3/4 + controlMargin + commentLabelHeight + controlMargin;
    } else if (imageurls.count==0) {
        self.normalNewsType = NormalNewsTypeNoPicture;
        self.cellHeight = verticalMargin + titleLabelHeight + controlMargin + descLabelHeight + controlMargin + commentLabelHeight + controlMargin;
    } else {
        self.normalNewsType = NormalNewsTypeSigalPicture;
        self.cellHeight = verticalMargin + titleLabelHeight + controlMargin + descLabelHeight + controlMargin + commentLabelHeight + controlMargin;
    }
    
    
}

@end
