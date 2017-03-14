//
//  AudioDownLoadTool.h
//  10音乐下载demo
//
//  Created by locklight on 17/3/14.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioDownLoadTool : NSObject

+ (instancetype)shareTool;

- (void)startTaskWithUrl:(NSURL *)url progress:(void(^)(float))progress completion:(void(^)(BOOL))completion;

- (BOOL)isDownloading:(NSURL *)url;

- (void)pauseWithUrl:(NSURL *)url;
@end
