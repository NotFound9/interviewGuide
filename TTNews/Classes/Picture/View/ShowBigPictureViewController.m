//
//  ShowBigPictureViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/3.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "ShowBigPictureViewController.h"
#import <SVProgressHUD.h>
#import <DALabeledCircularProgressView.h>
#import <UIImageView+WebCache.h>

@interface ShowBigPictureViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;
@property (weak, nonatomic) UIImageView *imageView;
@end

@implementation ShowBigPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat kDeviceWidth =[UIScreen mainScreen].bounds.size.width;
    CGFloat kDeviceHeight =[UIScreen mainScreen].bounds.size.height;

    CGFloat imageWidth = kDeviceWidth;
    CGFloat imageHeight = imageWidth * self.picture.height / self.picture.width;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    [imageView addGestureRecognizer:gesture];
    [self.scrollView addSubview:imageView];

    self.imageView = imageView;
    if (imageHeight <= kDeviceHeight) {
        imageView.frame = CGRectMake(0, (kDeviceHeight-imageHeight)*0.5, imageWidth, imageHeight);
    } else {
        imageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
        self.scrollView.contentSize = CGSizeMake(0, imageHeight);
    }
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.picture.image1] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        self.progressView.hidden = NO;
        CGFloat progress = 1.0*receivedSize/expectedSize;
        NSString *text = [NSString stringWithFormat:@"%.0f%%", 100*progress];
        self.progressView.progressLabel.text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self.progressView setProgress:progress animated:YES];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)savePicture:(id)sender {
    if (!self.imageView.image) {//如果图片不存在
        [SVProgressHUD showErrorWithStatus:@"请在图片加载完毕后再保存图片"];
    } else {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (IBAction)repostPicture:(id)sender {
    
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"保存失败\n%@",error]];
    } else {
        [SVProgressHUD showErrorWithStatus:@"保存成功"];

    }
    
}
@end
