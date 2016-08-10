//
//  MeTableViewController.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/25.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MeTableViewControllerDelegate <NSObject>
@optional
- (void)shakeCanChangeSkin:(BOOL)status;

@end

@interface MeTableViewController : UITableViewController

@property(nonatomic, weak) id<MeTableViewControllerDelegate> delegate;
@property (nonatomic, weak) UISwitch *changeSkinSwitch;

@end
