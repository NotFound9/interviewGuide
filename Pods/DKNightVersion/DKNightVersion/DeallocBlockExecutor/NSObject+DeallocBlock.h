//
//  NSObject+DeallocBlock.h
//  DKNightVersion
//
//  Created by nathanwhy on 16/2/24.
//  Copyright © 2016年 Draveness. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DeallocBlock)

- (id)addDeallocBlock:(void (^)())deallocBlock;

@end
