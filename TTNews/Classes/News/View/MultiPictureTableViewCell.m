//
//  MultiPictureTableViewCell.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/27.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "MultiPictureTableViewCell.h"
#import "TTNormalNews.h"
#import <UIImageView+WebCache.h>
#import <DKNightVersion.h>

@interface MultiPictureTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *newsTittleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UILabel *pictureCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorLine;

@end

@implementation MultiPictureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);

    self.newsTittleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.commentCountLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.pictureCountLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.separatorLine.dk_backgroundColorPicker = DKColorPickerWithKey(SEP);
}

-(void)setImageUrls:(NSArray *)imageUrls{
    _imageUrls = imageUrls;
    [self.imageView1 sd_setImageWithURL:imageUrls[0]];
    [self.imageView2 sd_setImageWithURL:imageUrls[1]];
    [self.imageView3 sd_setImageWithURL:imageUrls[2]];
    self.pictureCountLabel.text = [NSString stringWithFormat:@"%ld图  ", (unsigned long)imageUrls.count];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%d评论", arc4random()%1000];
}

-(void)setTheTitle:(NSString *)theTitle {
    _theTitle = theTitle;
    self.newsTittleLabel.text = theTitle;

}


@end
