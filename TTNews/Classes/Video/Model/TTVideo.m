//
//  TTVideo.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/2.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTVideo.h"
#import "TTVideoComment.h"
#import "TTVideoUser.h"
#import <MJExtension.h>
#import "TTConst.h"

@implementation TTVideo

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
        CGFloat videoX = 0;
        CGFloat videoY = cellTextY + TextHeight + cellMargin;
        CGFloat videoWidth = [UIScreen mainScreen].bounds.size.width;
        
        CGFloat videoHeight = self.height * videoWidth/self.width;
        self.videoFrame = CGRectMake(videoX, videoY, videoWidth, videoHeight);
        _cellHeight += videoHeight + cellMargin;
        
//        热评的高度
        TTVideoComment *cmt = self.top_cmt;
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

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.profile_image forKey:@"profile_image"];
    [aCoder encodeObject:self.screen_name forKey:@"screen_name"];
    [aCoder encodeObject:self.created_at forKey:@"created_at"];
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeObject:self.love forKey:@"love"];
    [aCoder encodeObject:self.cai forKey:@"cai"];
    [aCoder encodeObject:self.repost forKey:@"repost"];
    [aCoder encodeObject:self.comment forKey:@"comment"];
    [aCoder encodeObject:self.maxtime forKey:@"maxtime"];
    [aCoder encodeBool:self.sina_v forKey:@"sina_v"];
    [aCoder encodeFloat:self.width forKey:@"width"];
    [aCoder encodeFloat:self.height forKey:@"height"];
    [aCoder encodeObject:self.image0 forKey:@"image0"];
    [aCoder encodeObject:self.image1 forKey:@"image1"];
    [aCoder encodeObject:self.image2 forKey:@"image2"];
    [aCoder encodeObject:self.playcount forKey:@"playcount"];
    [aCoder encodeObject:self.videotime forKey:@"videotime"];
    [aCoder encodeObject:self.videouri forKey:@"videouri"];
    [aCoder encodeObject:self.top_cmt forKey:@"top_cmt"];
    [aCoder encodeFloat:self.cellHeight forKey:@"cellHeight"];
    [aCoder encodeCGRect:self.videoFrame forKey:@"videoFrame"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.profile_image = [aDecoder decodeObjectForKey:@"profile_image"];
        self.screen_name = [aDecoder decodeObjectForKey:@"screen_name"];
        self.created_at = [aDecoder decodeObjectForKey:@"created_at"];
        self.text = [aDecoder decodeObjectForKey:@"text"];
        self.love = [aDecoder decodeObjectForKey:@"love"];
        self.cai = [aDecoder decodeObjectForKey:@"cai"];
        self.repost = [aDecoder decodeObjectForKey:@"repost"];
        self.comment = [aDecoder decodeObjectForKey:@"comment"];
        self.maxtime = [aDecoder decodeObjectForKey:@"maxtime"];
        self.sina_v = [aDecoder decodeBoolForKey:@"sina_v"];
        self.width = [aDecoder decodeFloatForKey:@"width"];
        self.height = [aDecoder decodeFloatForKey:@"height"];
        self.image0 = [aDecoder decodeObjectForKey:@"image0"];
        self.image1 = [aDecoder decodeObjectForKey:@"image1"];
        self.image2 = [aDecoder decodeObjectForKey:@"image2"];
        self.playcount = [aDecoder decodeObjectForKey:@"playcount"];
        self.videotime = [aDecoder decodeObjectForKey:@"videotime"];
        self.videouri = [aDecoder decodeObjectForKey:@"videouri"];
        self.top_cmt = [aDecoder decodeObjectForKey:@"top_cmt"];
        self.cellHeight = [aDecoder decodeFloatForKey:@"cellHeight"];
        self.videoFrame = [aDecoder decodeCGRectForKey:@"videoFrame"];
    }
    return self;
}

@end
