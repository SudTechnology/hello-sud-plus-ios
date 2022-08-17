//
// Created by guanghui on 2022/7/5.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PkgDownloadStatus) {
    
    /** 等待执行 */
    PKG_DOWNLOAD_WAITING,
    
    /** 开始执行 */
    PKG_DOWNLOAD_STARTED,
    
    /** 下载中 */
    PKG_DOWNLOAD_DOWNLOADING,
    
    /** 已暂停 */
    PKG_DOWNLOAD_PAUSE,
    
    /** 已完成 */
    PKG_DOWNLOAD_COMPLETED,
    
    /** 已取消 */
    PKG_DOWNLOAD_CANCELED,
    
};
