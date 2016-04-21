//
//  EditUserInfoViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/18.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "EditUserInfoViewController.h"
#import "UIImage+Extension.h"
#import "TTConst.h"

@interface EditUserInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *signatureTextView;

@end

@implementation EditUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBasic];
}

-(void)setupBasic {
    self.title = @"个人信息";
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"headerImage"];
    self.headerImageView.image = [UIImage imageWithContentsOfFile:path];
    self.headerImageView.userInteractionEnabled = YES;
    [self.headerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeaderImage)]];
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width *0.5;
    self.headerImageView.layer.masksToBounds = YES;
    self.nameTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:UserNameKey];
    self.signatureTextView.text = [[NSUserDefaults standardUserDefaults] stringForKey:UserSignatureKey];
    self.signatureTextView.layer.cornerRadius = 5;
    self.signatureTextView.layer.masksToBounds = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:self.nameTextField.text forKey:UserNameKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.signatureTextView.text forKey:UserSignatureKey];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSkinModel) name:SkinModelDidChangedNotification object:nil];
    [self updateSkinModel];
}

-(void)updateSkinModel {
    NSString *currentSkinModel = [[NSUserDefaults standardUserDefaults] stringForKey:CurrentSkinModelKey];
    if ([currentSkinModel isEqualToString:NightSkinModelValue]) {
        self.view.backgroundColor = [UIColor blackColor];
        self.nameTextField.backgroundColor = [UIColor darkGrayColor];
        self.signatureTextView.backgroundColor = [UIColor darkGrayColor];
        self.nameTextField.textColor =[UIColor grayColor];
        self.signatureTextView.textColor = [UIColor grayColor];
    } else {//日间模式
        self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        self.nameTextField.backgroundColor = [UIColor whiteColor];
        self.signatureTextView.backgroundColor = [UIColor whiteColor];
        self.nameTextField.textColor =[UIColor blackColor];
        self.signatureTextView.textColor = [UIColor blackColor];
    }
}


- (void)changeHeaderImage {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.allowsEditing = YES;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo  {
    self.headerImageView.image = [image circleImage];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"headerImage"];
    [UIImagePNGRepresentation(self.headerImageView.image) writeToFile:path atomically:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



@end
