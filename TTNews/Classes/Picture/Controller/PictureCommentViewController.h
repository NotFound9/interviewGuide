//
//  PictureCommentViewController.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/25.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTPicture;

@interface PictureCommentViewController : UIViewController
/** 帖子模型 */
@property (nonatomic, strong) TTPicture *picture;

@end
