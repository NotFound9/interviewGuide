//
//  MultiPictureTableViewCell.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/27.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "MultiPictureTableViewCell.h"
#import "TTNormalNews.h"
#import "UIImageView+Extension.h"

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setImageUrls:(NSArray *)imageUrls{
    _imageUrls = imageUrls;
    [self.imageView1 TT_setImageWithURL:imageUrls[0][@"url"]];
    [self.imageView2 TT_setImageWithURL:imageUrls[1][@"url"]];
    [self.imageView3 TT_setImageWithURL:imageUrls[2][@"url"]];
    self.pictureCountLabel.text = [NSString stringWithFormat:@"%ld图  ",(unsigned long)imageUrls.count];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%d评论",arc4random()%1000];
}

-(void)setTitle:(NSString *)title {
    _title = title;
    self.newsTittleLabel.text = title;

}

-(void)updateToDaySkinMode {
    self.newsTittleLabel.textColor = [UIColor blackColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.separatorLine.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0  blue:240/255.0  alpha:1.0];

}

-(void)updateToNightSkinMode {
    self.newsTittleLabel.textColor = [UIColor grayColor];
    self.contentView.backgroundColor = [UIColor colorWithRed:42/255.0 green:39/255.0 blue:43/255.0 alpha:1.0];
    self.separatorLine.backgroundColor = [UIColor colorWithRed:40/255.0 green:36/255.0  blue:40/255.0  alpha:1.0];
}

@end
