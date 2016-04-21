//
//  TTDataTool.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/7.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TTVideo;
@class TTHeaderNews;
@class TTVideoFetchDataParameter;
@class TTPictureFetchDataParameter;
@class TTNormalNewsFetchDataParameter;
@interface TTDataTool : NSObject

+(void)videoWithParameters:(TTVideoFetchDataParameter *)videoParameters success:(void (^)(NSArray *array, NSString *maxtime))success failure:(void (^)(NSError *error))failure;

+ (void)videoHotCommentWithParameters:(NSMutableDictionary *)parameters success:(void (^)(NSArray *hotArray, NSArray *latestArray, NSInteger total))success failure:(void (^)(NSError *error))failure;

+ (void)videoMoreCommentWithParameters:(NSMutableDictionary *)parameters success:(void (^)(NSArray *latestArray, NSInteger total))success failure:(void (^)(NSError *error))failure;

+(void)pictureWithParameters:(TTPictureFetchDataParameter *)pictureParameters success:(void (^)(NSArray *array, NSString *maxtime))success failure:(void (^)(NSError *error))failure;


+(void)TTNormalNewsWithParameters:(TTNormalNewsFetchDataParameter *)normalNewsParameters success:(void (^)(NSMutableArray *array))success failure:(void (^)(NSError *error))failure;

+(void)TTHeaderNewsFromServerOrCacheWithMaxTTHeaderNews:(TTHeaderNews *)headerNews success:(void (^)(NSMutableArray *array))success failure:(void (^)(NSError *error))failure;

+(void)deletePartOfCacheInSqlite;


@end
