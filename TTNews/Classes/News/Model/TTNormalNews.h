//
//  NormalNews.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/24.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TTNormalNews : NSObject

typedef NS_ENUM(NSUInteger, NormalNewsType) {
    NormalNewsTypeNoPicture = 1,
    NormalNewsTypeSigalPicture = 2,
    NormalNewsTypeMultiPicture = 3,//图片大于等于三张
};

@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *desc;//简介
@property (nonatomic, strong) NSArray *imageurls;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *pubDate;//发布日期
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger allPages;

//自己定义的变量
@property (nonatomic, assign) NormalNewsType normalNewsType;
@property (nonatomic, assign) NSInteger createdtime;//发布日期
@property (nonatomic, assign) CGFloat cellHeight;

@end
