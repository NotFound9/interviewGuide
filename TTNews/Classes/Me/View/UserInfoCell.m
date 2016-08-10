
//
//  UserInfoCell.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/8/10.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "UserInfoCell.h"
#import <DKNightVersion.h>

@interface UserInfoCell()
@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *contentLabel;
@end
@implementation UserInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat cellHeight = 100;
        CGFloat margin = 10;
        CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
 
        UIImageView *avatarImageView = [[UIImageView alloc] init];
        self.avatarImageView = avatarImageView;
        avatarImageView.frame =CGRectMake(margin, margin, cellHeight - 2*margin, cellHeight - 2*margin);
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width * 0.5;
        avatarImageView.layer.masksToBounds = YES;
        [self addSubview:avatarImageView];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        self.nameLabel = nameLabel;
        CGFloat nameLabelHeight = 21.5;
        nameLabel.font = [UIFont systemFontOfSize:18];
        
        nameLabel.frame = CGRectMake(CGRectGetMaxX(avatarImageView.frame) + margin, avatarImageView.frame.origin.y +avatarImageView.frame.size.height*0.5 - nameLabelHeight-0.5*margin, kScreenWidth - 3*margin -avatarImageView.frame.size.width, nameLabelHeight);
        nameLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        [self addSubview:nameLabel];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        self.contentLabel = contentLabel;
        CGFloat contentLabelHeight = 17.5;
        
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.textColor = [UIColor grayColor];
        contentLabel.frame = CGRectMake(CGRectGetMaxX(avatarImageView.frame) + margin, avatarImageView.frame.origin.y +avatarImageView.frame.size.height*0.5+0.5*margin, kScreenWidth - 3*margin -avatarImageView.frame.size.width, contentLabelHeight);
        contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        contentLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        [self addSubview:contentLabel];

        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);

    }
    return self;
}

- (void)setAvatarImage:(UIImage *)image Name:(NSString *)name Signature:(NSString *)content {
    self.avatarImageView.image = image;
    self.nameLabel.text = name;
    self.contentLabel.text = content;
    
}
@end
