//
//  DKColorTable.m
//  DKNightVersion
//
//  Created by Draveness on 15/12/11.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import "DKColorTable.h"

@interface DKColorTable ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, UIColor *> *> *table;
@property (nonatomic, strong, readwrite) NSArray<DKThemeVersion *> *themes;

@end

@implementation DKColorTable

UIColor *DKColorFromRGB(NSUInteger hex) {
    return [UIColor colorWithRed:((CGFloat)((hex >> 16) & 0xFF)/255.0) green:((CGFloat)((hex >> 8) & 0xFF)/255.0) blue:((CGFloat)(hex & 0xFF)/255.0) alpha:1.0];
}

UIColor *DKColorFromRGBA(NSUInteger hex) {
    return [UIColor colorWithRed:((CGFloat)((hex >> 24) & 0xFF)/255.0) green:((CGFloat)((hex >> 16) & 0xFF)/255.0) blue:((CGFloat)((hex >> 8) & 0xFF)/255.0) alpha:((CGFloat)(hex & 0xFF)/255.0)];
}

+ (instancetype)sharedColorTable {
    static DKColorTable *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[DKColorTable alloc] init];
        sharedInstance.file = @"DKColorTable.txt";
    });
    return sharedInstance;
}

- (void)reloadColorTable {
    // Clear previos color table
    self.table = nil;
    self.themes = nil;

    // Load color table file
    NSString *filepath = [[NSBundle mainBundle] pathForResource:self.file.stringByDeletingPathExtension ofType:self.file.pathExtension];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];

    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);

    NSLog(@"DKColorTable:\n%@", fileContents);


    NSMutableArray *entries = [[fileContents componentsSeparatedByString:@"\n"] mutableCopy];
    [entries removeObjectAtIndex:0]; // Remove theme entry

    self.themes = [self themesFromContents:fileContents];

    // Add entry to color table
    for (NSString *entry in entries) {
        NSArray *colors = [self colorsFromEntry:entry];
        NSString *key = [self keyFromEntry:entry];

        [self addEntryWithKey:key colors:colors themes:self.themes];
    }
}

- (NSArray *)themesFromContents:(NSString *)content {
    NSString *rawThemes = [content componentsSeparatedByString:@"\n"].firstObject;
    return [self separateString:rawThemes];
}

- (NSArray *)colorsFromEntry:(NSString *)entry {
    NSMutableArray *colors = [[self separateString:entry] mutableCopy];
    [colors removeLastObject];
    NSMutableArray *result = [@[] mutableCopy];
    for (NSString *number in colors) {
        [result addObject:[self colorFromString:number]];
    }
    return result;
}

- (NSString *)keyFromEntry:(NSString *)entry {
    return [self separateString:entry].lastObject;
}

- (void)addEntryWithKey:(NSString *)key colors:(NSArray *)colors themes:(NSArray *)themes {
    NSParameterAssert(themes.count == colors.count);

    __block NSMutableDictionary *themeToColorDictionary = [@{} mutableCopy];

    [themes enumerateObjectsUsingBlock:^(NSString * _Nonnull theme, NSUInteger idx, BOOL * _Nonnull stop) {
        [themeToColorDictionary setValue:colors[idx] forKey:theme];
    }];

    [self.table setValue:themeToColorDictionary forKey:key];
}

- (DKColorPicker)pickerWithKey:(NSString *)key {
    NSParameterAssert(key);

    NSDictionary *themeToColorDictionary = [self.table valueForKey:key];
    DKColorPicker picker = ^(DKThemeVersion *themeVersion) {
        return [themeToColorDictionary valueForKey:themeVersion];
    };
    return picker;

}

#pragma mark - Getter/Setter

- (NSMutableDictionary *)table {
    if (!_table) {
        _table = [[NSMutableDictionary alloc] init];
    }
    return _table;
}

- (void)setFile:(NSString *)file {
    _file = file;
    [self reloadColorTable];
}

#pragma mark - Helper

- (UIColor*)colorFromString:(NSString*)hexStr {
    hexStr = [hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([hexStr hasPrefix:@"0x"]) {
        hexStr = [hexStr substringFromIndex:2];
    }
    if([hexStr hasPrefix:@"#"]) {
        hexStr = [hexStr substringFromIndex:1];
    }

    NSUInteger hex = [self intFromHexString:hexStr];
    if(hexStr.length > 6) {
        return DKColorFromRGBA(hex);
    }

    return DKColorFromRGB(hex);
}

- (NSUInteger)intFromHexString:(NSString *)hexStr {
    unsigned int hexInt = 0;

    NSScanner *scanner = [NSScanner scannerWithString:hexStr];

    [scanner scanHexInt:&hexInt];

    return hexInt;
}

- (NSArray *)separateString:(NSString *)string {
    NSArray *array = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return[array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
}

@end
