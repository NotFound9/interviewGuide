//
//  SendFeedbackViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/18.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "SendFeedbackViewController.h"
#import "TTConst.h"
#import <SVProgressHUD.h>

@interface SendFeedbackViewController ()<UITextViewDelegate>

@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UILabel *placeholderLabel;

@end

@implementation SendFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBasic];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSkinModel) name:SkinModelDidChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self updateSkinModel];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)updateSkinModel {
    NSString *currentSkinModel = [[NSUserDefaults standardUserDefaults] stringForKey:CurrentSkinModelKey];
    if ([currentSkinModel isEqualToString:NightSkinModelValue]) {
        self.view.backgroundColor = [UIColor blackColor];
        self.textView.backgroundColor= [UIColor darkGrayColor];
        self.textView.textColor = [UIColor lightGrayColor];
    } else {//日间模式
        self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        self.textView.backgroundColor= [UIColor whiteColor];
        self.textView.textColor = [UIColor blackColor];
    }
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGRect frame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat margin = 20;
    self.textView.frame = CGRectMake(margin, CGRectGetMaxY(self.navigationController.navigationBar.frame) + margin, [UIScreen mainScreen].bounds.size.width - 2*margin, frame.origin.y - 2*margin - CGRectGetMaxY(self.navigationController.navigationBar.frame));
}

-(void)setupBasic {
    self.title = @"反馈";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendFeedBack)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    UITextView *textView = [[UITextView alloc] init];
    self.textView = textView;
    CGFloat margin = 20;
    textView.frame = CGRectMake(margin, CGRectGetMaxY(self.navigationController.navigationBar.frame) + margin, [UIScreen mainScreen].bounds.size.width - 2*margin, [UIScreen mainScreen].bounds.size.height - 2*margin - CGRectGetMaxY(self.navigationController.navigationBar.frame));
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:18];
    [textView becomeFirstResponder];
    textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    [self.view addSubview:textView];
 
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel = placeholderLabel;
    placeholderLabel.text = [NSString stringWithFormat:@"请输入反馈,我们将为您不断改进"];
    placeholderLabel.textColor = [UIColor grayColor];
    placeholderLabel.frame = CGRectMake(textView.frame.origin.x + 10, textView.frame.origin.y + 10, textView.frame.size.width - 20, 20);
    [self.view addSubview:placeholderLabel];
    
    CGFloat buttonWidth = 30;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - buttonWidth - 10, 5, buttonWidth, buttonWidth);
    [button addTarget:self action:@selector(dissmissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"KBSkinToolbar_icon_hide"] forState:UIControlStateNormal];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:button];
    textView.inputAccessoryView = view;
}

-(void)sendFeedBack {
    [SVProgressHUD showSuccessWithStatus:@"发送成功！"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dissmissKeyboard {
    [self.textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

@end
