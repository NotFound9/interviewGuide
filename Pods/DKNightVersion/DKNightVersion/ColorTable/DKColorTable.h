//
//  DKColorTable.h
//  DKNightVersion
//
//  Created by Draveness on 15/12/11.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKNightVersionManager.h"

/**
 *  A convinient macro to create DKColorPicker block.
 *
 *  @param key Key for corresponding entry in table
 *
 *  @return DKColorPicker
 */
#define DKColorPickerWithKey(key) [[DKColorTable sharedColorTable] pickerWithKey:@#key]

/**
 *  DKColorTable is a new feature in 2.x, which providing you a very convinient and
 *  delightful approach to manage all your color in an iOS project. Besides that, we
 *  support multiple themes with DKColorTable, change your `DKColorTable.txt` file 
 *  like this:
 *  
 *  Ex:
 *
 *      NORMAL   NIGHT   RED
 *      #ffffff  #343434 #ff0000 BG
 *      #aaaaaa  #313131 #ff0000 SEP
 *
 *  And you can directly change `[DKNightVersionManager sharedManager].themeVersion` to
 *  what you want, like: `RED` `NORMAL` and `NIGHT`. And trigger to post notification 
 *  and update corresponding color.
 */
@interface DKColorTable : NSObject

/**
 *  Call `- reloadColorTable` will trigger `DKColorTable` to load this file,
 *  default is `DKColorTable.txt`. Don't need to call `- reloadColorTable` after
 *  setting this property, cuz we have already do it for you.
 */
@property (nonatomic, strong) NSString *file;

/**
 *  An array of DKThemeVersion, order is exactly the same in `file`.
 */
@property (nonatomic, strong, readonly) NSArray<DKThemeVersion *> *themes;

/**
 *  Return color table instance, you MUST use this method instead of `- init`,
 *  `- init` method may have negative impact on your performance.
 *
 *  @return An instance of DKColorTable
 */
+ (instancetype)sharedColorTable;

/**
 *  Reload `file` into memory, and reconstrcut the whole color table. This method
 *  will clear color table and use current `file` to load color table again.
 */
- (void)reloadColorTable;

/**
 *  Return a `DKColorPicker` with `key`, but I suggest you use marcho `DKColorPickerWithKey(key)`
 *  instead of calling this method.
 *
 *  Ex:
 *
 *      NORMAL   NIGHT
 *      #ffffff  #343434 BG
 *      #aaaaaa  #313131 SEP
 *  
 *      self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
 *
 *  If current themeVersion is NORMAL, view's background color will be set to #ffffff. When theme
 *  changes, it will automatically reload color from global color table and update current color
 *  again.
 *
 *  @param key Which indicates the entry you refer to
 *
 *  @return An DKColorPicker block
 */
- (DKColorPicker)pickerWithKey:(NSString *)key;

@end
