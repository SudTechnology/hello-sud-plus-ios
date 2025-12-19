#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 日志级别
typedef NS_ENUM(NSInteger, SudLogType) {
    SudLogVERBOSE = 2,
    SudLogDEBUG = 3,
    SudLogINFO = 4,
    SudLogWARN = 5,
    SudLogERROR = 6,
    SudLogASSERT = 7
};

@protocol ISudLogger <NSObject>
- (void) setLogLevel:(SudLogType) level;
- (void) log:(SudLogType) level tag:(NSString*) tag msg:(NSString*) msg detailLine:(NSString *)detailLine;
- (void) log:(SudLogType) level tag:(NSString*) tag msg:(NSString*) msg error:(nullable NSError *) error detailLine:(NSString *)detailLine;
@end

NS_ASSUME_NONNULL_END
