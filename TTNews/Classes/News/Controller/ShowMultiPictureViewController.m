//
//  ShowMultiPictureViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/31.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "ShowMultiPictureViewController.h"
#import <UIImageView+WebCache.h>
#import "TTConst.h"
#import <DKNightVersion.h>

@interface ShowMultiPictureViewController ()

@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UIButton *backButton;

@end

@implementation ShowMultiPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x343434, 0xfafafa);
    [self setupScrollView];
    [self setupTextView];
    [self setupBackButton];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
   
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark --private method--初始化scrollView
-(void)setupScrollView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.frame;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*self.imageUrls.count, 0);
    scrollView.pagingEnabled = YES;
    for (NSInteger i = 0; i<self.imageUrls.count; i++) {
        NSDictionary *dict = self.imageUrls[i];
        UIImageView *imageView =[[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)]];
        imageView.frame = CGRectMake(i*scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"url"]]];
        [scrollView addSubview:imageView];
    }
    
    [self.view addSubview:scrollView];
    
}

#pragma mark --private method--初始化TextView
- (void)setupTextView {
    UITextView *textView = [[UITextView alloc] init];
    self.textView = textView;
    textView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height *0.7, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height *0.25);
    textView.alpha = 0.7;
    textView.backgroundColor = [UIColor blackColor];
    textView.textColor = [UIColor whiteColor];
    textView.font = [UIFont systemFontOfSize:16];
    textView.text = self.text;
    textView.userInteractionEnabled = NO;
    [self.view addSubview:textView];
}

#pragma mark --private method--初始化返回按钮
-(void)setupBackButton {
    CGFloat margin= 10;
    CGFloat buttonWidthHeight = 35;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton = backButton;
    backButton.frame = CGRectMake(margin, [UIApplication sharedApplication].statusBarFrame.size.height + margin, buttonWidthHeight, buttonWidthHeight);
    [backButton setBackgroundImage:[UIImage imageNamed:@"show_image_back_icon"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
}

#pragma mark --private method--点击了ImageView
-(void)clickImageView:(id)sender{
    self.backButton.hidden = !self.backButton.hidden;
    self.textView.hidden = !self.textView.hidden;
}

#pragma mark --private method--返回到上一个控制器
-(void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
}



         
         
         
@end
