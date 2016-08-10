//
//  PictureTableViewCell.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/3.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTPicture;

@protocol  PictureTableViewCellDelegate<NSObject>
@optional

-(void)clickMoreButton:(TTPicture *)picture;
-(void)clickCommentButton:(NSIndexPath *)indexPath;

@end

@interface PictureTableViewCell : UITableViewCell

+(instancetype)cell;

@property (nonatomic, strong) TTPicture *picture;
@property (nonatomic, weak) id<PictureTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
