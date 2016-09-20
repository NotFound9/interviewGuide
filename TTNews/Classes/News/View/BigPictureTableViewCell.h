//
//  BigPictureTableViewCell.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/9/19.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigPictureTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *LblTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@end
