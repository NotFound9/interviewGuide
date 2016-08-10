//
//  AppInfoViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/18.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "AppInfoViewController.h"
#import "TTConst.h"

@interface AppInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;

@end

@implementation AppInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
