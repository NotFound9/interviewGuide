//
//  NSObject+Night.h
//  DKNightVersion
//
//  Created by Draveness on 15/11/7.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKNightVersionManager.h"

@interface NSObject (Night)

/**
 *  Default global DKNightVersionManager, this property gives us a more
 *  convinient way to access it.
 */
@property (nonatomic, strong, readonly) DKNightVersionManager *dk_manager;

@end
