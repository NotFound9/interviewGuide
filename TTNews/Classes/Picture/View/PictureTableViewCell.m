//
//  PictureTableViewCell.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/3.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "PictureTableViewCell.h"
#import "TTPicture.h"
#import "TTPictureComment.h"
#import "TTPictureUser.h"
#import "ShowBigPictureViewController.h"
#import "UIImageView+Extension.h"
#import "UIImage+Extension.h"
#import <DALabeledCircularProgressView.h>

@interface PictureTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UIButton *hatebutton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageview;
@property (weak, nonatomic) IBOutlet UILabel *topCommentTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *topCommentLabel;
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIView *separatorLine1;
@property (weak, nonatomic) IBOutlet UIView *separatorLine2;
@property (weak, nonatomic) IBOutlet UIView *separatorLine3;
@property (weak, nonatomic) IBOutlet UIView *separatorLine4;

@end

@implementation PictureTableViewCell

+(instancetype)cell {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
- (void)awakeFromNib {
    self.progressView.roundedCorners = 2;
    self.progressView.progressLabel.textColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = imageView;
    
    
}

-(void)setPicture:(TTPicture *)picture {
    _picture = picture;
    [self.headerImageView TT_setImageWithURL:[NSURL URLWithString:picture.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage *image, NSError *error) {
        self.headerImageView.image = [image circleImage];
    }];
    self.nameLabel.text = picture.screen_name;
    self.TimeLabel.text = picture.created_at;
    self.contentLabel.text = picture.text;
    self.vipImageView.hidden = !picture.isSina_v;
    
    NSString *extension = picture.image1.pathExtension;
    [self.pictureImageView TT_setImageWithURL:[NSURL URLWithString:picture.image1] placeholderImage:[UIImage imageNamed:@"allplaceholderImage"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        CGFloat progress = 1.0*receivedSize/expectedSize;
        NSString *text = [NSString stringWithFormat:@"%.0f%%", 100*progress];
        self.progressView.progressLabel.text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self.progressView setProgress:progress animated:YES];
        
    } completed:^(UIImage *image, NSError *error) {
        self.progressView.hidden = YES;
        if (picture.isBigPicture) {
        UIGraphicsBeginImageContextWithOptions(picture.pictureFrame.size, YES, 0.0);
            CGFloat width = picture.pictureFrame.size.width;
            CGFloat height = width * image.size.height / image.size.width;
            [image drawInRect:CGRectMake(0, 0, width, height)];
            self.pictureImageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }];
    
    if (![extension.lowercaseString isEqualToString:@"gif"]) {
        self.gifImageview.hidden = YES;
    }
    
    if (picture.isBigPicture) {//大图
        self.seeBigPictureButton.hidden = NO;
        self.pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        
    } else {//非大图
        self.seeBigPictureButton.hidden = YES;
        self.pictureImageView.contentMode = UIViewContentModeScaleToFill;
    }
    
    [self setupButton:self.loveButton WithTittle:picture.love];
    [self setupButton:self.hatebutton WithTittle:picture.cai];
    [self setupButton:self.repostButton WithTittle:picture.repost];
    [self setupButton:self.commentButton WithTittle:picture.comment];
    
    
    TTPictureComment *comment = picture.top_cmt;
    if(comment) {
        self.topCommentLabel.text = [NSString stringWithFormat:@"%@ : %@",comment.user.username, comment.content];
        self.topCommentTopLabel.text = @"最热评论";
    } else {
        self.topCommentLabel.text = @"";
        self.topCommentTopLabel.text = @"";

    }
    
    
}

- (void)setupButton:(UIButton *)button WithTittle:(NSString *)tittle {
    double number = tittle.doubleValue;
    if (number > 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万",number/10000] forState:UIControlStateNormal];
        return;
    }
    [button setTitle:tittle forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



- (IBAction)more:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickMoreButton:)]) {
        [self.delegate clickMoreButton:self.picture];
    }
    
}

- (void)setFrame:(CGRect)frame {
    static CGFloat margin = 10;
//    frame.origin.y = frame.origin.y + margin;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    frame.size.height = self.picture.cellHeight - margin;
    [super setFrame:frame];
}
- (IBAction)seeBigPicture:(id)sender {
    
    ShowBigPictureViewController *viewController = [[ShowBigPictureViewController alloc] init];
    viewController.picture = self.picture;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:viewController animated:YES completion:nil];
}

-(void)updateToDaySkinMode {
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    self.separatorLine1.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0  blue:240/255.0  alpha:1.0];
    self.separatorLine2.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0  blue:240/255.0  alpha:1.0];
    self.separatorLine3.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0  blue:240/255.0  alpha:1.0];
    self.separatorLine4.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0  blue:240/255.0  alpha:1.0];
    [self.seeBigPictureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)updateToNightSkinMode {
    self.contentLabel.textColor = [UIColor grayColor];
    self.contentView.backgroundColor = [UIColor colorWithRed:42/255.0 green:39/255.0 blue:43/255.0 alpha:1.0];
    self.backgroundColor = [UIColor colorWithRed:42/255.0 green:39/255.0 blue:43/255.0 alpha:1.0];
    self.separatorLine1.backgroundColor = [UIColor colorWithRed:40/255.0 green:36/255.0  blue:40/255.0  alpha:1.0];
    self.separatorLine2.backgroundColor = [UIColor colorWithRed:40/255.0 green:36/255.0  blue:40/255.0  alpha:1.0];
    self.separatorLine3.backgroundColor = [UIColor colorWithRed:40/255.0 green:36/255.0  blue:40/255.0  alpha:1.0];
    self.separatorLine4.backgroundColor = [UIColor colorWithRed:40/255.0 green:36/255.0  blue:40/255.0  alpha:1.0];
    [self.seeBigPictureButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

}

@end
