//
//  NSObject+DeallocBlock.m
//  DKNightVersion
//
//  Created by nathanwhy on 16/2/24.
//  Copyright © 2016年 Draveness. All rights reserved.
//

#import "NSObject+DeallocBlock.h"
#import "DKDeallocBlockExecutor.h"
#import <objc/runtime.h>

static void *kNSObject_DeallocBlocks;

@implementation NSObject (DeallocBlock)

- (id)addDeallocBlock:(void (^)())deallocBlock {
    if (deallocBlock == nil) {
        return nil;
    }
    
    NSMutableArray *deallocBlocks = objc_getAssociatedObject(self, &kNSObject_DeallocBlocks);
    if (deallocBlocks == nil) {
        deallocBlocks = [NSMutableArray array];
        objc_setAssociatedObject(self, &kNSObject_DeallocBlocks, deallocBlocks, OBJC_ASSOCIATION_RETAIN);
    }
    // Check if the block is already existed
    for (DKDeallocBlockExecutor *executor in deallocBlocks) {
        if (executor.deallocBlock == deallocBlock) {
            return nil;
        }
    }
    
    DKDeallocBlockExecutor *executor = [DKDeallocBlockExecutor executorWithDeallocBlock:deallocBlock];
    [deallocBlocks addObject:executor];
    return executor;
}

@end
