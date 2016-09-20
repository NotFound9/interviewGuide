//
//  SXNewsCell.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/24.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.//

#import <UIKit/UIKit.h>
#import "SXNewsEntity.h"

@interface SXNewsCell : UITableViewCell

@property(nonatomic,strong) SXNewsEntity *NewsModel;



/**
 *  类方法返回可重用的id
 */
+ (NSString *)idForRow:(SXNewsEntity *)NewsModel;

/**
 *  类方法返回行高
 */
+ (CGFloat)heightForRow:(SXNewsEntity *)NewsModel;
@end
