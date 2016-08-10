//
//  DKNightVersion.h
//  DKNightVerision
//
//  Created by Draveness on 4/14/15.
//  Copyright (c) 2015 Draveness. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for DKNightVersion.
FOUNDATION_EXPORT double DKNightVersionVersionNumber;

//! Project version string for DKNightVersion.
FOUNDATION_EXPORT const unsigned char DKNightVersionVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <DKNightVersion/PublicHeader.h>

#ifndef _DKNIGHTVERSION_
#define _DKNIGHTVERSION_

#import <objc/runtime.h>

#import <DKNightVersion/DKColor.h>
#import <DKNightVersion/DKImage.h>
#import <DKNightVersion/DKNightVersionManager.h>
#import <DKNightVersion/NSObject+Night.h>

#import <DKNightVersion/DKColorTable.h>

#import <DKNightVersion/CoreAnimation+Night.h>

#import <DKNightVersion/UIBarButtonItem+Night.h>
#import <DKNightVersion/UIControl+Night.h>
#import <DKNightVersion/UILabel+Night.h>
#import <DKNightVersion/UINavigationBar+Night.h>
#import <DKNightVersion/UIPageControl+Night.h>
#import <DKNightVersion/UIProgressView+Night.h>
#import <DKNightVersion/UISearchBar+Night.h>
#import <DKNightVersion/UISlider+Night.h>
#import <DKNightVersion/UISwitch+Night.h>
#import <DKNightVersion/UITabBar+Night.h>
#import <DKNightVersion/UITableView+Night.h>
#import <DKNightVersion/UITextField+Night.h>
#import <DKNightVersion/UITextView+Night.h>
#import <DKNightVersion/UIToolbar+Night.h>
#import <DKNightVersion/UIView+Night.h>
#import <DKNightVersion/UIButton+Night.h>
#import <DKNightVersion/UIImageView+Night.h>

#import <DKNightVersion/metamacros.h>
#import <DKNightVersion/EXTKeyPathCoding.h>

#define _DKSetterWithPROPERTYerty(LOWERCASE) [NSString stringWithFormat:@"set%@:", [[[LOWERCASE substringToIndex:1] uppercaseString] stringByAppendingString:[LOWERCASE substringFromIndex:1]]]

#define pickerify(KLASS, PROPERTY) interface \
    KLASS (Night) \
    @property (nonatomic, copy, setter = dk_set ## PROPERTY ## Picker:) DKColorPicker dk_ ## PROPERTY ## Picker; \
    @end \
    @interface \
    KLASS () \
    @property (nonatomic, strong) NSMutableDictionary<NSString *, DKColorPicker> *pickers; \
    @end \
    @implementation \
    KLASS (Night) \
    - (DKColorPicker)dk_ ## PROPERTY ## Picker { \
        return objc_getAssociatedObject(self, @selector(dk_ ## PROPERTY ## Picker)); \
    } \
    - (void)dk_set ## PROPERTY ## Picker:(DKColorPicker)picker { \
        objc_setAssociatedObject(self, @selector(dk_ ## PROPERTY ## Picker), picker, OBJC_ASSOCIATION_COPY_NONATOMIC); \
        [self setValue:picker(self.dk_manager.themeVersion) forKeyPath:@keypath(self, PROPERTY)];\
        [self.pickers setValue:[picker copy] forKey:_DKSetterWithPROPERTYerty(@#PROPERTY)]; \
    } \
    @end


#endif /* _DKNIGHTVERSION_ */
