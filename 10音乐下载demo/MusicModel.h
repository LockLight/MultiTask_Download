//
//  MusicModel.h
//  10音乐下载demo
//
//  Created by HM09 on 17/3/12.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject



/**
 音乐的id
 */
@property (nonatomic, copy) NSString *audioId;

/**
 音乐的标题
 */
@property (nonatomic, copy) NSString *name;

/**
 音乐的下载地址
 */
@property (nonatomic, copy) NSString *path;

/**
 音乐的大小
 */
@property (nonatomic, copy) NSString *size;

@end
