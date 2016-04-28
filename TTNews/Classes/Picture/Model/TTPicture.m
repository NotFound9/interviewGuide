//
//  TTPicture.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/3.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTPicture.h"
#import "TTPictureComment.h"
#import "TTPictureUser.h"
#import <MJExtension.h>
#import "TTConst.h"

@implementation TTPicture

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id",
             @"top_cmt":@"top_cmt[0]"
             };
}

-(CGFloat)cellHeight {
    if (!_cellHeight) {
        
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2*cellMargin, MAXFLOAT);
        CGFloat TextHeight = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
        
        _cellHeight = cellMargin+cellTextY + TextHeight;
        
        //videoImageview的高度
        CGFloat pictureX = 0;
        CGFloat pictureY =  cellTextY + TextHeight + cellMargin;
        CGFloat pictureWidth = [UIScreen mainScreen].bounds.size.width;
        
        CGFloat pictureHeight = self.height * pictureWidth/self.width;
        if (pictureHeight > [UIScreen mainScreen].bounds.size.height-64-40) {
            self.bigPicture = YES;
            pictureHeight = maxSize.width * 9/16;
        } else {
            self.bigPicture = NO;
        }
        self.pictureFrame = CGRectMake(pictureX, pictureY, pictureWidth, pictureHeight);
        _cellHeight += pictureHeight + cellMargin;
        
        
        //热评的高度
        TTPictureComment *cmt = self.top_cmt;
        if (cmt) {//最热评论存在
            NSString *content = [NSString stringWithFormat:@"%@ : %@", cmt.user.username, cmt.content];
            CGFloat topCommentHeight = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 ]} context:nil].size.height;
            
            _cellHeight += 0.5*cellMargin + cellTopCommentTopLabelHeight+topCommentHeight + 0.5*cellMargin + cellBottomBarHeight;
        } else {
            _cellHeight += 0.5*cellMargin+ 0.5*cellMargin +cellBottomBarHeight;
        }
        
    }
    
    return _cellHeight;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self= [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [self mj_encode:aCoder];
}

@end
