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
@end
@interface PictureTableViewCell : UITableViewCell

+(instancetype)cell;
-(void)updateToDaySkinMode;
-(void)updateToNightSkinMode;
@property (nonatomic, strong) TTPicture *picture;
@property (nonatomic, weak) id<PictureTableViewCellDelegate> delegate;

@end
