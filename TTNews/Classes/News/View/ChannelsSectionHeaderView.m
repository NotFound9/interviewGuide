//
//  ChannelsSectionHeaderView.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/5/1.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "ChannelsSectionHeaderView.h"
#import <DKNightVersion.h>
@interface ChannelsSectionHeaderView()

@end

@implementation ChannelsSectionHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x343434, 0xfafafa);

        CGFloat margin = 15;
        UILabel *label = [[UILabel alloc] init];
        self.titleLabel = label;
        label.frame = CGRectMake(margin, 0, [UIScreen mainScreen].bounds.size.width - 2*margin, frame.size.height);
        [self addSubview:label];
    }
    return self;
}



@end
