
//
//  SwitchCell.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/8/10.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "SwitchCell.h"
#import <DKNightVersion.h>

@implementation SwitchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        self.leftLabel = label;
        label.frame = CGRectMake(15, 0, 120, self.frame.size.height);
        label.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        [self addSubview:label];
        UISwitch *theSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.frame.size.width - 60, 6, 50, self.frame.size.height)];
        self.theSwitch = theSwitch;
        [self addSubview:theSwitch];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);

    }
    return self;
}



@end
