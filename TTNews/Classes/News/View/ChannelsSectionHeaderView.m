//
//  ChannelsSectionHeaderView.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/5/1.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "ChannelsSectionHeaderView.h"

@interface ChannelsSectionHeaderView()

@end

@implementation ChannelsSectionHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        CGFloat margin = 15;
        UILabel *label = [[UILabel alloc] init];
        self.titleLabel = label;
        label.frame = CGRectMake(margin, 0, [UIScreen mainScreen].bounds.size.width - 2*margin, frame.size.height);
        [self addSubview:label];
    }
    return self;
}

#pragma mark 切换至日间模式
-(void)updateToDaySkinMode {
    self.titleLabel.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
}

#pragma mark 切换至夜间模式
-(void)updateToNightSkinMode {
    self.titleLabel.textColor = [UIColor grayColor];
    self.backgroundColor = [UIColor colorWithRed:42/255.0 green:39/255.0 blue:43/255.0 alpha:1.0];
}

@end
