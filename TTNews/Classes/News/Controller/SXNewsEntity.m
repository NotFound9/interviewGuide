//
//  SXNewsEntity.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/24.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.//

#import "SXNewsEntity.h"
#import <MJExtension.h>
#import "SinglePictureNewsTableViewCell.h"
#import "MultiPictureTableViewCell.h"

@implementation SXNewsEntity

+ (instancetype)newsModelWithDict:(NSDictionary *)dict
{
    SXNewsEntity *model = [[self alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    [model setValuesForKeysWithDictionary:dict];
//    if (model.hasHead && model.photosetID) {
//        model.cellName =  @"TopImageCell";
//    }else if (model.hasHead){
//        model.cellName =  @"TopTxtCell";
//    }else if (model.imgType){
//        model.cellName =  @"BigImageCell";
    
    
    CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat horizontalMargin = 10;
    CGFloat verticalMargin = 15;
    CGFloat controlMargin = 5;
    CGFloat titleLabelHeight = 19.5;
    CGFloat descLabelHeight = 31;
    CGFloat commentLabelHeight = 13.5;
    
    if (model.imgextra.count == 2) {
        model.cellHeight = verticalMargin + titleLabelHeight + horizontalMargin + ((kScreenWidth - 4 *horizontalMargin)/3)*3/4 + controlMargin + commentLabelHeight + controlMargin;
    } else {
        model.cellHeight = verticalMargin + titleLabelHeight + controlMargin + descLabelHeight + controlMargin + commentLabelHeight + controlMargin;
    }

    
    return model;
}

-(void)setImgextra:(NSArray *)imgextra {
    CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat horizontalMargin = 10;
    CGFloat verticalMargin = 15;
    CGFloat controlMargin = 5;
    CGFloat titleLabelHeight = 19.5;
    CGFloat descLabelHeight = 31;
    CGFloat commentLabelHeight = 13.5;
    
    if (self.imgextra.count == 2) {
        self.cellHeight = verticalMargin + titleLabelHeight + horizontalMargin + ((kScreenWidth - 4 *horizontalMargin)/3)*3/4 + controlMargin + commentLabelHeight + controlMargin;
    } else {
        self.cellHeight = verticalMargin + titleLabelHeight + controlMargin + descLabelHeight + controlMargin + commentLabelHeight + controlMargin;
    }
}
@end
