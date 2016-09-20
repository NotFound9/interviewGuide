//
//  ContentTableViewController.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/26.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTNormalNews;

@interface ContentTableViewController : UITableViewController

@property(nonatomic, strong) TTNormalNews *news;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *channelName;
@property(nonatomic,copy) NSString *urlString;
@property (nonatomic,assign) NSInteger index;

@end
