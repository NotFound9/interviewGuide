//
//  VideoCommentCell.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/2.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTPictureComment;

@interface PictureCommentCell : UITableViewCell
/** 评论 */
@property (nonatomic, strong) TTPictureComment *comment;

@end
