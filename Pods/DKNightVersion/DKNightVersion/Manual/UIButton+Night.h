//
//  UIButton+Night.h
//  DKNightVersion
//
//  Created by Draveness on 15/12/9.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+Night.h"

@interface UIButton (Night)

- (void)dk_setTitleColorPicker:(DKColorPicker)picker forState:(UIControlState)state;

- (void)dk_setBackgroundImage:(DKImagePicker)picker forState:(UIControlState)state;

- (void)dk_setImage:(DKImagePicker)picker forState:(UIControlState)state;

@end
