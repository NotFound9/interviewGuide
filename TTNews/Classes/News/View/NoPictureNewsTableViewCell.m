//
//  NoPictureNewsTableViewCell.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/14.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "NoPictureNewsTableViewCell.h"
#import <DKNightVersion.h>

@interface NoPictureNewsTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorLine;

@end

@implementation NoPictureNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%d评论",arc4random()%1000];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    self.newsTitleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.contentLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.commentCountLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.separatorLine.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    self.newsTitleLabel.text = titleText;
}

-(void)setContentText:(NSString *)contentText {
    _contentText = contentText;
    self.newsTitleLabel.text  = contentText;
}



@end
