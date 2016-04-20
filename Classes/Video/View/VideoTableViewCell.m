//
//  VideoTableViewCell.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/2.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "TTVideo.h"
#import "TTVideoComment.h"
#import "TTVideoUser.h"
#import "UIImage+Extension.h"
#import "UIImageView+Extension.h"
#import "VideoPlayView.h"

@interface VideoTableViewCell()<VideoPlayViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *AddFriendsButton;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UIButton *hatebutton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UILabel *topCommentTopLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UILabel *topCommentLabel;
@property (weak, nonatomic) IBOutlet UIView *VideoContianerView;

@property (weak, nonatomic) IBOutlet UIView *separatorLine1;
@property (weak, nonatomic) IBOutlet UIView *separatorLine2;
@property (weak, nonatomic) IBOutlet UIView *separatorLine3;
@property (weak, nonatomic) IBOutlet UIView *separatorLine4;

@end
@implementation VideoTableViewCell


+(instancetype)cell {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
- (void)awakeFromNib {
    self.nameLabel.textColor = [UIColor colorWithRed:243/255.0 green:75/255.0 blue:80/255.0 alpha:1.0];
    self.autoresizingMask = NO;
    self.autoresizesSubviews = NO;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = imageView;
    
}

- (void)setVideo:(TTVideo *)video {
    _video = video;
    [self.headerImageView TT_setImageWithURL:[NSURL URLWithString:video.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage *image, NSError *error) {
            self.headerImageView.image = [image circleImage];

    }];
    self.nameLabel.text = video.screen_name;
    self.createdTimeLabel.text = video.created_at;
    self.contentLabel.text = video.text;
    self.vipImageView.hidden = !video.isSina_v;
    
    NSInteger count = video.playcount.integerValue;
    if (count>10000) {
        self.playCountLabel.text = [NSString stringWithFormat:@"%ld万播放",count/10000];
    } else {
        self.playCountLabel.text = [NSString stringWithFormat:@"%ld播放",(long)count];
    }
    NSInteger time = video.videotime.integerValue;
    self.timelabel.text = [NSString stringWithFormat:@"%02ld%02ld",time/60,time%60];
    [self.videoImageView TT_setImageWithURL:[NSURL URLWithString:video.image1]];

    
    [self setupButton:self.loveButton WithTittle:video.love];
    [self setupButton:self.hatebutton WithTittle:video.cai];
    [self setupButton:self.repostButton WithTittle:video.repost];
    [self setupButton:self.commentButton WithTittle:video.comment];
    
    
    TTVideoComment *comment = video.top_cmt;
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

- (IBAction)playVideo:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickVideoButton:)]) {
        [self.delegate clickVideoButton:self.indexPath];
    }
}

- (IBAction)more:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickMoreButton:)]) {
        [self.delegate clickMoreButton:self.video];
    }
    NSLog(@"%@-----%@",NSStringFromCGRect(self.topCommentTopLabel.frame), NSStringFromCGRect(self.topCommentLabel.frame));
}

- (void)setFrame:(CGRect)frame {
    static CGFloat margin = 10;

    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    frame.size.height = self.video.cellHeight - margin;
    [super setFrame:frame];
}

-(void)updateToDaySkinMode {
    self.contentLabel.textColor = [UIColor blackColor];
    self.playCountLabel.backgroundColor = [UIColor darkGrayColor];
    self.timelabel.backgroundColor = [UIColor darkGrayColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    self.separatorLine1.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0  blue:240/255.0  alpha:1.0];
    self.separatorLine2.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0  blue:240/255.0  alpha:1.0];
    self.separatorLine3.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0  blue:240/255.0  alpha:1.0];
    self.separatorLine4.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0  blue:240/255.0  alpha:1.0];

}
-(void)updateToNightSkinMode {
    self.contentLabel.textColor = [UIColor grayColor];
    self.playCountLabel.backgroundColor = [UIColor blackColor];
    self.timelabel.backgroundColor = [UIColor blackColor];
    self.contentView.backgroundColor = [UIColor colorWithRed:42/255.0 green:39/255.0 blue:43/255.0 alpha:1.0];
    self.backgroundColor = [UIColor colorWithRed:42/255.0 green:39/255.0 blue:43/255.0 alpha:1.0];
    self.separatorLine1.backgroundColor = [UIColor colorWithRed:40/255.0 green:36/255.0  blue:40/255.0  alpha:1.0];
    self.separatorLine2.backgroundColor = [UIColor colorWithRed:40/255.0 green:36/255.0  blue:40/255.0  alpha:1.0];
    self.separatorLine3.backgroundColor = [UIColor colorWithRed:40/255.0 green:36/255.0  blue:40/255.0  alpha:1.0];
    self.separatorLine4.backgroundColor = [UIColor colorWithRed:40/255.0 green:36/255.0  blue:40/255.0  alpha:1.0];
}


@end
