//
//  TTHeaderNews.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/29.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//
/*"title": "开车急刹时需不需要同时踩下离合？",
 "url": "http://toutiao.com/group/6235360158509105409/",
 "abstract": "有人说踩下离合会延长制动距离，如果是下坡路这个可以理解，平地的话是不是也是如此，为什么？这个问题，看似比较简单，其实内藏玄机。一起来研究一下制动的艺术吧。1、先上结论：紧急刹车情况下，要想缩短制动距离，最快时间踩下刹车才是王道，踩不踩离合的差别远没有踩下刹车时间的快慢来得差别大。",
 "image_url": "http://p3.pstatp.com/list/4d000684a532e30833"*/

#import <Foundation/Foundation.h>

@interface TTHeaderNews : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *image_url;
@property(nonatomic, copy) NSString *abstract;

@end
