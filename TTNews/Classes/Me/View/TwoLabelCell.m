
//
//  TwoLabelCell.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/8/10.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TwoLabelCell.h"
#import <DKNightVersion.h>

@implementation TwoLabelCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *label1 = [[UILabel alloc] init];
        self.leftLabel = label1;
        label1.frame = CGRectMake(15, 0, 120, self.frame.size.height);
        label1.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        [self addSubview:label1];
       
        UILabel *label2 = [[UILabel alloc] init];
        self.rightLabel = label2;
        label2.frame = CGRectMake(self.frame.size.width-90, 0, 80, self.frame.size.height);
        label2.textAlignment= NSTextAlignmentRight;
        label2.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        [self addSubview:label2];
        self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
        
    }
    return self;
}
@end
