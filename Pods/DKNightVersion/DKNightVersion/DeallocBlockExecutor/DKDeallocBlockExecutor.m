//
//  DeallocBlockExecutor.m
//  DKNightVersion
//
//  Created by nathanwhy on 16/2/24.
//  Copyright © 2016年 Draveness. All rights reserved.
//

#import "DKDeallocBlockExecutor.h"

@implementation DKDeallocBlockExecutor

+ (instancetype)executorWithDeallocBlock:(void (^)())deallocBlock {
    DKDeallocBlockExecutor *o = [DKDeallocBlockExecutor new];
    o.deallocBlock = deallocBlock;
    return o;
}

- (void)dealloc {
    if (self.deallocBlock) {
        self.deallocBlock();
        self.deallocBlock = nil;
    }
}
@end
