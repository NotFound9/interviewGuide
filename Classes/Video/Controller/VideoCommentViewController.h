//
//  VideoCommentViewController.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/3.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//
#import <UIKit/UIKit.h>

@class TTVideo;
@class VideoTableViewCell;
@interface VideoCommentViewController : UIViewController
/** 帖子模型 */
@property (nonatomic, strong) TTVideo *video;

@end
