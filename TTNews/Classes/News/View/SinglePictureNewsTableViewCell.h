//
//  SinglePictureNewsTableViewCell.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/26.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXNewsEntity.h"
@interface SinglePictureNewsTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *pictureArray;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *contentTittle;
@property (nonatomic, copy) NSString *desc;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *LblTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end
