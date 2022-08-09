#import <Foundation/Foundation.h>
#import "PkgDownloadStatus.h"

NS_ASSUME_NONNULL_BEGIN


@protocol ISudListenerPreloadMGPkg <NSObject>

-(void) onPreloadSuccess:(int64_t) mgId;

-(void) onPreloadFailure:(int64_t) mgId errCode:(int) errCode errMsg:(NSString *) errMsg;

-(void) onPreloadStatus:(int64_t) mgId downloadedSize:(long) downloadedSize totalSize:(long) totalSize status:(PkgDownloadStatus) status;

@end

NS_ASSUME_NONNULL_END
