//
//  AudioDownLoadTool.m
//  10音乐下载demo
//
//  Created by locklight on 17/3/14.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "AudioDownLoadTool.h"
#import "NSString+CZHash.h"

@interface AudioDownLoadTool ()<NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableDictionary *taskDic;
@property (nonatomic, strong) NSMutableDictionary *progressDic;
@property (nonatomic, strong) NSMutableDictionary *completionDic;
@end

@implementation AudioDownLoadTool{
    NSData *_resumeData;
}

+ (instancetype)shareTool{
    static id tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[AudioDownLoadTool alloc]initWithSession];
    });
    return tool;
}

- (instancetype)initWithSession{
    if(self = [super init]){
        //初始化
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:NULL];
        _taskDic = [NSMutableDictionary dictionary];
        _progressDic = [NSMutableDictionary dictionary];
        _completionDic = [NSMutableDictionary dictionary];
    }
    return self;
}




#pragma  mark - 下载相关方法
//开始下载
- (void)startTaskWithUrl:(NSURL *)url progress:(void(^)(float))progress completion:(void(^)(BOOL))completion{
    //1.根据reumeData 创建task
    NSURLSessionDownloadTask *task = nil;
    if(_resumeData == nil){
        task = [_session downloadTaskWithURL:url];
    }else{
        task = [_session downloadTaskWithResumeData:_resumeData];
    }

    //2.将task存入task字典,将block添加进block字典
    [_taskDic setObject:task forKey:url];
    [_progressDic setObject:progress forKey:task];
    [_completionDic setObject:completion forKey:task];
    //下载任务开始
    [task resume];
}

//正在下载
- (BOOL)isDownloading:(NSURL *)url{
    NSURLSessionDownloadTask *task = _taskDic[url];
    return task != nil;
}

- (void)pauseWithUrl:(NSURL *)url{
    __block NSURLSessionDownloadTask *task = _taskDic[url];
    [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        //写入缓存
        [resumeData writeToFile:[self resumeDataPath:url] atomically:YES];
        //记录resumeData
        _resumeData = resumeData;
        //清空dic
        [_taskDic removeObjectForKey:task.currentRequest.URL];
        [_progressDic removeObjectForKey:task];
        [_completionDic removeObjectForKey:task];
        
        task = nil;
    }];
}

- (NSString *)resumeDataPath:(NSURL *)url{
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *fileMd5Name = [url.absoluteString cz_md5String];
    NSString *resumeDataPath = [NSString stringWithFormat:@"%@/%@",cacheDir,fileMd5Name];
    return resumeDataPath;
}


#pragma mark -NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
                              didFinishDownloadingToURL:(NSURL *)location{
    void (^completionBlock)(BOOL) = _completionDic[downloadTask];
    //执行block
    dispatch_async(dispatch_get_main_queue(), ^{
        completionBlock(YES);
        //从字典内移除
        [_taskDic removeObjectForKey:downloadTask.currentRequest.URL];
        [_progressDic removeObjectForKey:downloadTask];
        [_completionDic removeObjectForKey:downloadTask];
        
        //清空resumeData
        NSURL *url = downloadTask.currentRequest.URL;
        [[NSFileManager defaultManager] removeItemAtPath:[self resumeDataPath:url] error:NULL];
    });
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
                                           didWriteData:(int64_t)bytesWritten
                                      totalBytesWritten:(int64_t)totalBytesWritten
                              totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    float progress = (float)totalBytesWritten/totalBytesExpectedToWrite;
    //更新当前下载进度
    void (^progressBlock)(float) = _progressDic[downloadTask];
    dispatch_async(dispatch_get_main_queue(), ^{
        progressBlock(progress);
    });
}


@end
