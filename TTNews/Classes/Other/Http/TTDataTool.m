//
//  TTDataTool.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/7.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//缓存数据的工具类

#import "TTDataTool.h"
#import "TTVideo.h"
#import "TTPicture.h"
#import "TTHeaderNews.h"
#import "TTConst.h"
#import "TTVideoFetchDataParameter.h"
#import "TTPictureFetchDataParameter.h"
#import "TTNormalNewsFetchDataParameter.h"
#import "TTNormalNews.h"
#import "TTJudgeNetworking.h"
#import "TTVideoComment.h"
#import <FMDB.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "TTNetworkManager.h"
#import <AFNetworking.h>

@interface TTDataTool()

@end

@implementation TTDataTool
static FMDatabaseQueue *_queue;
static NSString * const apikey = @"8b72ce2839d6eea0869b4c2c60d2a449";

+(void)initialize {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"data.sqlite"];
//    NSLog(@"%@",path);
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists table_video(id integer primary key autoincrement, idstr text, time integer, video blob);"];
        
        [db executeUpdate:@"create table if not exists table_picture(id integer primary key autoincrement, idstr text, time integer, picture blob);"];
        
        [db executeUpdate:@"create table if not exists table_ttheadernews(id integer primary key autoincrement, title text, url text, desc text, picUrl text, ctime text);"];
       
        [db executeUpdate:@"create table if not exists table_normalnews(id integer primary key autoincrement, channelid text, title text, imageurls blob, desc text, link text, pubdate text, createdtime integer, source text);"];
        [db executeUpdate:@"create table if not exists table_videocomment(id integer primary key autoincrement, idstr text, page integer, hotcommentarray blob, latestcommentarray blob, total integer);"];
    }];
}

+(void)videoWithParameters:(TTVideoFetchDataParameter *)videoParameters success:(void (^)(NSArray *array, NSString *maxtime))success failure:(void (^)(NSError *error))failure {

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(41);
    parameters[@"page"] = @(videoParameters.page);
    if (videoParameters.maxtime) {
        parameters[@"maxtime"] = videoParameters.maxtime;
    }
    
    [[TTNetworkManager shareManager] Get:@"http://api.budejie.com/api/api_open.php" Parameters:parameters Success:^(NSURLSessionDataTask *task, id responseObject) {
                NSArray *array = [TTVideo mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
                NSString *maxTime = responseObject[@"info"][@"maxtime"];
                for (TTVideo *video in array) {
                    video.maxtime = maxTime;
                }
                success(array,maxTime);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self addVideoArray:array];
                });

            } Failure:^(NSError *error) {
                videoParameters.recentTime = nil;
                videoParameters.remoteTime = nil;
                NSMutableArray *videoArray = [self selectDataFromCacheWithVideoParameters:videoParameters];
                if (videoArray.count>0) {
                    TTVideo *lastVideo = videoArray.lastObject;
                    NSString *maxtime = lastVideo.maxtime;
                    success(videoArray, maxtime);
                }
                success([videoArray copy], @"");
            }];
}


+(NSMutableArray *)selectDataFromCacheWithVideoParameters:(TTVideoFetchDataParameter *)parameters {
    __block NSMutableArray *videoArray = nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        videoArray = [NSMutableArray array];
        FMResultSet *result = nil;
        
        if (parameters.recentTime) {//时间更大，代表消息发布越靠后，因为时间是按real来储存的
            NSInteger time = [[[parameters.recentTime stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""].integerValue;
            
            result = [db executeQuery:@"select * from table_video where time > ? order by time desc limit 0,20;", @(time)];
            
        }
        
        if(parameters.remoteTime) {
            NSInteger time = [[[parameters.remoteTime stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""].integerValue;
            result = [db executeQuery:@"select * from table_video where time < ? order by time desc limit 0,20;",@(time)];
        }
        
        if (parameters.remoteTime==nil &&parameters.recentTime==nil){
            result = [db executeQuery:@"select * from table_video order by time desc limit 0,20;"];
            
        }
        
        while (result.next) {
            NSData *data = [result dataForColumn:@"video"];
            TTVideo *video = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [videoArray addObject:video];
        }
        
    }];
    return videoArray;
}

+(void)addVideoArray:(NSArray *)videoArray {
    for (TTVideo *video in videoArray) {
        [self addVideo:video];
    }
}

+(void)addVideo:(TTVideo *)video {
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *idstr = video.ID;
        FMResultSet *result = nil;
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM table_video WHERE idstr = '%@';",idstr];
        result = [db executeQuery:querySql];
        if (result.next==NO) {//不存在此条数据
            NSString *string = video.created_at;
            NSInteger time = [[[string stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""].integerValue;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:video];
            [db executeUpdate:@"insert into table_video (idstr,time,video) values(?,?,?);", idstr, @(time), data];
        }
        [result close];
        
    }];
}


+(void)pictureWithParameters:(TTPictureFetchDataParameter *)pictureParameters success:(void (^)(NSArray *array, NSString *maxtime))success failure:(void (^)(NSError *error))failure {            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(10);
    parameters[@"page"] = @(pictureParameters.page);
    if (pictureParameters.maxtime) {
        parameters[@"maxtime"] = pictureParameters.maxtime;
    }
    
    [[TTNetworkManager shareManager] Get:@"http://api.budejie.com/api/api_open.php" Parameters:parameters Success:^(NSURLSessionDataTask *task, id responseObject) {
        
                NSArray *array = [TTPicture mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
                NSString *maxTime = responseObject[@"info"][@"maxtime"];
                for (TTPicture *picture in array) {
                    picture.maxtime = maxTime;
                }
                success(array,maxTime);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self addPictureArray:array];
                });

            } Failure:^(NSError *error) {
                pictureParameters.recentTime = nil;
                pictureParameters.remoteTime = nil;
                NSMutableArray *pictureArray = [self selectDataFromCacheWithPictureParameters:pictureParameters];
                if (pictureArray.count>0) {
                    TTPicture *lastPicture = pictureArray.lastObject;
                    NSString *maxtime = lastPicture.maxtime;
                    success([pictureArray copy], maxtime);
                }
                success([pictureArray copy], @"");
            }];
}


+(NSMutableArray *)selectDataFromCacheWithPictureParameters:(TTPictureFetchDataParameter *)parameters {
    __block NSMutableArray *pictureArray = nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        pictureArray = [NSMutableArray array];
        FMResultSet *result = nil;
        
        if (parameters.recentTime) {//时间更大，代表消息发布越靠后，因为时间是按real来储存的
            NSInteger time = [[[parameters.recentTime stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""].integerValue;
            
            result = [db executeQuery:@"select * from table_picture where time > ? order by time desc limit 0,20;", @(time)];
            
        }
        
        if(parameters.remoteTime) {
            NSInteger time = [[[parameters.remoteTime stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""].integerValue;
            result = [db executeQuery:@"select * from table_picture where time < ? order by time desc limit 0,20;",@(time)];
        }
        
        if (parameters.remoteTime==nil && parameters.recentTime==nil){
            result = [db executeQuery:@"select * from table_picture order by time desc limit 0,20;"];
            
        }
        
        while (result.next) {
            NSData *data = [result dataForColumn:@"picture"];
            TTPicture *picture = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [pictureArray addObject:picture];
        }
        
    }];
    return pictureArray;

}

+(void)addPicture:(TTPicture *)picture {
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *idstr = picture.ID;
        FMResultSet *result = nil;
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM table_picture WHERE idstr = '%@';",idstr];
        result = [db executeQuery:querySql];
        if (result.next==NO) {//不存在此条数据
            NSString *string = picture.created_at;
            NSInteger time = [[[string stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""].integerValue;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:picture];
            [db executeUpdate:@"insert into table_picture (idstr,time,picture) values(?,?,?);", idstr, @(time), data];
        }
        [result close];
    }];
}

+ (void)addPictureArray:(NSArray *)pictureArray {
    for (TTPicture *picture in pictureArray) {
        [self addPicture:picture];
    }
}

+ (void)TTHeaderNewsFromServerOrCacheWithMaxTTHeaderNews:(TTHeaderNews *)headerNews success:(void (^)(NSMutableArray *array))success failure:(void (^)(NSError *error))failure {
    
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:@"8b72ce2839d6eea0869b4c2c60d2a449" forHTTPHeaderField:@"apikey"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"num"] = @20;
        [manager GET:@"http://apis.baidu.com/txapi/social/social" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSMutableArray *headerNewsArray = [TTHeaderNews mj_objectArrayWithKeyValuesArray:responseObject[@"newslist"]];
            NSMutableArray *temmArray = [NSMutableArray array];
            for (TTHeaderNews *headerNews in headerNewsArray) {
                if (![headerNews.picUrl isEqualToString:@""]) {
                    [temmArray addObject:headerNews];
                }
                if (temmArray.count>=5) break;
            }
            
            success(temmArray);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self addTTHeaderNewsArray:[temmArray copy]];
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
            [SVProgressHUD showErrorWithStatus:@"无网络连接"];
            NSMutableArray *array = [self TTHeaderNewsFromCacheWithMaxTTHeaderNews:headerNews];
                    success(array);
            NSLog(@"%@",error);
        }];

//    [[TTNetworkManager shareManager] Get2:@"http://apis.baidu.com/songshuxiansheng/news/news" Parameters:nil Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
//        NSMutableArray *headerNewsArray = [TTHeaderNews mj_objectArrayWithKeyValuesArray:responseObject[@"retData"]];
//        NSArray *temmArray = [headerNewsArray copy];
//        for (TTHeaderNews *headerNews in temmArray) {
//            if ([headerNews.image_url isEqualToString:@""]) {
//                [headerNewsArray removeObject:headerNews];
//            }
//        }
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [self addTTHeaderNewsArray:[headerNewsArray copy]];
//        });
//        
//        success(headerNewsArray);
//    } Failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"无网络连接"];
//        NSMutableArray *array = [self TTHeaderNewsFromCacheWithMaxTTHeaderNews:headerNews];
//                success(array);
//        NSLog(@"%@",error);
//        }];
}

+(NSMutableArray *)TTHeaderNewsFromCacheWithMaxTTHeaderNews:(TTHeaderNews *)headerNews {
    __block NSMutableArray *headerNewsArray;
        [_queue inDatabase:^(FMDatabase *db) {
            headerNewsArray = [NSMutableArray array];
            FMResultSet *result = nil;
                result = [db executeQuery:@"select * from table_ttheadernews order by id desc limit 0,5"];
            while (result.next) {
                TTHeaderNews *headerNews = [[TTHeaderNews alloc] init];
                headerNews.title = [result stringForColumn:@"title"];
                headerNews.url = [result stringForColumn:@"url"];
                headerNews.picUrl = [result stringForColumn:@"picUrl"];
                headerNews.desc = [result stringForColumn:@"desc"];
                headerNews.ctime = [result stringForColumn:@"ctime"];

                [headerNewsArray addObject:headerNews];
            }
        }];
    return headerNewsArray;
}


+(void)addTTHeaderNews:(TTHeaderNews *)news {
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *url = news.url;
        FMResultSet *result = nil;
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM table_ttheadernews WHERE url = '%@';",url];
        result = [db executeQuery:querySql];
        if (result.next==NO) {//不存在此条数据
            [db executeUpdate:@"insert into table_ttheadernews (title ,url, desc, picUrl, ctime) values(?,?,?,?,?);",news.title, news.url, news.desc, news.picUrl, news.ctime];
        }
        [result close];
    }];
}

+(void)addTTHeaderNewsArray:(NSArray *)headerNewsArray {
    for (TTHeaderNews *news in headerNewsArray) {
        [self addTTHeaderNews:news];
    }
}

+(void)TTNormalNewsWithParameters:(TTNormalNewsFetchDataParameter *)normalNewsParameters success:(void (^)(NSMutableArray *array))success failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"channelid"] = normalNewsParameters.channelId;
    parameters[@"channelName"] = [normalNewsParameters.channelName stringByAppendingString:@"最新"];
    parameters[@"title"] = normalNewsParameters.title;
    parameters[@"page"] = @(normalNewsParameters.page);

    [[TTNetworkManager shareManager] Get2:@"http://apis.baidu.com/showapi_open_bus/channel_news/search_news" Parameters:parameters Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        NSMutableArray *pictureArray = [TTNormalNews mj_objectArrayWithKeyValuesArray:responseObject[@"showapi_res_body"][@"pagebean"][@"contentlist"]];
        for (TTNormalNews *news in pictureArray) {
            news.allPages = [responseObject[@"showapi_res_body"][@"pagebean"][@"allPages"] integerValue];
        }
     
        success(pictureArray);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self addTTNormalNewsArray:pictureArray];
        });
    } Failure:^(NSError *error) {
        failure(error);
        TTNormalNewsFetchDataParameter *tempParameters = [[TTNormalNewsFetchDataParameter alloc] init];
            tempParameters.channelId = normalNewsParameters.channelId;
            NSMutableArray *tempCacheArray = [self selectDataFromTTNormalNewsCacheWithParameters:tempParameters];
            success(tempCacheArray);
    }];
}


+(NSMutableArray *)selectDataFromTTNormalNewsCacheWithParameters:(TTNormalNewsFetchDataParameter *)parameters {
    __block NSMutableArray *newsArray = nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        newsArray = [NSMutableArray array];
        FMResultSet *result = nil;
        if (parameters.recentTime!=0) {//时间更大，代表消息发布越靠后，因为时间是按real来储存的
            NSInteger time = parameters.recentTime;
            NSString *sql = [NSString stringWithFormat:@"select * from table_normalnews where createdtime > %@ and channelid = '%@' order by createdtime desc limit 0,20;", @(time),parameters.channelId];

            result = [db executeQuery:sql];
            
        }
        
        if(parameters.remoteTime!=0) {
            NSInteger time = parameters.remoteTime;
            NSString *sql = [NSString stringWithFormat:@"select * from table_normalnews where createdtime < %@ and channelid = '%@' order by createdtime desc limit 0,20;", @(time),parameters.channelId];
            
            result = [db executeQuery:sql];
        }
        
        if (parameters.remoteTime==0 && parameters.recentTime==0){
            
            NSString *sql = [NSString stringWithFormat:@"select * from table_normalnews where channelid = '%@' order by createdtime desc limit 0,20;", parameters.channelId];
            result = [db executeQuery:sql];
        }
     
        while (result.next) {
            TTNormalNews *news = [[TTNormalNews alloc] init];
            news.title = [result stringForColumn:@"title"];
            news.pubDate = [result stringForColumn:@"pubdate"];
            news.createdtime  = [result longLongIntForColumn:@"createdtime"];
            
            news.imageurls = [NSKeyedUnarchiver unarchiveObjectWithData:[result dataForColumn:@"imageurls"]];
            news.source = [result stringForColumn:@"source"];
            news.desc = [result stringForColumn:@"desc"];
            news.link = [result stringForColumn:@"link"];
            news.channelId = [result stringForColumn:@"channelId"];
            [newsArray addObject:news];
        }
    }];
    return newsArray;
    
}


+(void)addTTNormalNews:(TTNormalNews *)news {
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = nil;
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM table_normalnews WHERE link = '%@';",news.link];
        result = [db executeQuery:querySql];
        if (result.next==NO) {//不存在此条数据
            NSData *imageurls = [NSKeyedArchiver archivedDataWithRootObject:news.imageurls];
            [db executeUpdate:@"insert into table_normalnews (title , pubdate, createdtime, source, desc, link, imageurls, channelid) values(?,?,?,?,?,?,?,?);",news.title, news.pubDate, @(news.createdtime), news.source, news.desc, news.link, imageurls,news.channelId];
        }
        [result close];
    }];
}

+(void)addTTNormalNewsArray:(NSMutableArray *)newsArray {
    for (TTNormalNews *news in newsArray) {
        [self addTTNormalNews:news];
    }
}

+(void)deletePartOfCacheInSqlite {
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from table_video where id > 20"];
        [db executeUpdate:@"delete from table_picture where id > 20"];
        [db executeUpdate:@"delete from table_normalnews where id > 20"];
        [db executeUpdate:@"delete from table_ttheadernews where id > 5"];
    }];
}

+(void)VideoCommentsWithParameters:(NSMutableDictionary *)parameters success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
      [[TTNetworkManager shareManager] Get:@"http://api.budejie.com/api/api_open.php" Parameters:parameters Success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } Failure:^(NSError *error) {
        failure(error);
    }];
}

+(void)PictureCommentsWithParameters:(NSMutableDictionary *)parameters success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    [[TTNetworkManager shareManager] Get:@"http://api.budejie.com/api/api_open.php" Parameters:parameters Success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } Failure:^(NSError *error) {
        failure(error);
    }];
}

@end
