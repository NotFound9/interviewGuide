//
//  TTHeaderNews.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/29.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//
//"ctime": "2016-09-12 09:15",
//"title": "英国一跳伞爱好者高空跳伞 因伞包未开丧生",
//"description": "网易社会",
//"picUrl": "http://s.cimg.163.com/catchpic/9/9F/9F29B5C5B9153D694B76A23A8372C9A6.jpg.119x83.jpg",
//"url": "http://news.163.com/16/0912/09/C0OJP248000146BE.html#f=slist"
#import <Foundation/Foundation.h>

@interface TTHeaderNews : NSObject

@property(nonatomic, copy) NSString *ctime;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, copy) NSString *picUrl;
@property(nonatomic, copy) NSString *url;

@end
