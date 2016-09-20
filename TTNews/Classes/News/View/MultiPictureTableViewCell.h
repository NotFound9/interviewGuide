//
//  MultiPictureTableViewCell.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/27.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiPictureTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *imageUrls;
@property (nonatomic, copy) NSString *theTitle;
@property (nonatomic, copy) NSString *iconImage;

@end
