//
//  VideoCommentCell.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/2.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "PictureCommentCell.h"
#import "TTPictureComment.h"
#import "UIImageView+Extension.h"
#import "TTPictureUser.h"
#import "UIImage+Extension.h"
#import <DKNightVersion.h>

@interface PictureCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@end

@implementation PictureCommentCell

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

- (void)awakeFromNib
{
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    self.contentLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.usernameLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.likeCountLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);

    
    
//    self.profileImageView.layer.cornerRadius = self.profileImageView.width * 0.5;
//    self.profileImageView.layer.masksToBounds = YES;
}

- (void)setComment:(TTPictureComment *)comment
{
    _comment = comment;
    
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self.profileImageView TT_setImageWithURL:[NSURL URLWithString:comment.user.profile_image] placeholderImage:placeholder completed:^(UIImage *image, NSError *error) {
        self.profileImageView.image = image ? [image circleImage] : placeholder;
    }];
    
    
    self.sexView.image = [comment.user.sex isEqualToString:@"m"] ? [UIImage imageNamed:@"Profile_manIcon"] : [UIImage imageNamed:@"Profile_womanIcon"];
    self.contentLabel.text = comment.content;
    self.usernameLabel.text = comment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd", comment.like_count];
    
    if (comment.voiceUrl.length) {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''", comment.voicetime] forState:UIControlStateNormal];
    } else {
        self.voiceButton.hidden = YES;
    }
}


@end
