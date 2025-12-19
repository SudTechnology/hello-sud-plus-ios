#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define GAME_INFO_ORIENTATION_LANDSCAPE 0
#define GAME_INFO_ORIENTATION_PORTRAIT 1
#define GAME_INFO_ORIENTATION_UNSPECIFIED 2

typedef enum : NSUInteger {
    GAME_STATUS_NOT_INSTALLED = 0,
    GAME_STATUS_DOWNLOADING,
    GAME_STATUS_DOWNLOADED,
    GAME_STATUS_DOWNLOAD_FAILED,
    GAME_STATUS_INSTALLING,
    GAME_STATUS_INSTALLED,
    GAME_STATUS_INSTALL_FAILED
} GameStatus;

@interface GameInfo : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, assign) NSInteger orientation;
@property (nonatomic, assign) BOOL showStatusBar;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *appID;
@property (nonatomic, copy) NSString *gameHash;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSArray<NSString *> *require;
@property (nonatomic, copy) NSArray<NSString *> *tags;
@property (nonatomic, assign, readonly) BOOL isInstalled;
@property (nonatomic, assign) GameStatus status;
@property (nonatomic, copy) NSString *errorMsg;
@property (nonatomic, assign) float installPercent;
@property (nonatomic, assign) long downloadedSize;
@property (nonatomic, assign) long totalDownloadSize;
@property(nonatomic, strong)NSString *tag;

- (instancetype)initWithJSON:(NSDictionary *)json;
@end

NS_ASSUME_NONNULL_END
