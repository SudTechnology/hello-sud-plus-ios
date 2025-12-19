#import "GameInfo.h"

//#import "GameListModel.h"

static NSString * const _KEY_APP_ID = @"app_id";
static NSString * const _KEY_HASH = @"hash";
static NSString * const _KEY_NAME = @"name";
static NSString * const _KEY_ORIENTATION = @"orientation";
static NSString * const _KEY_SCREEN_MODE = @"screen_mode";
static NSString * const _KEY_TAG = @"tags";
static NSString * const _KEY_VERSION = @"version";
static NSString * const _KEY_REQUIRE = @"require";

@implementation GameInfo

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        self.orientation = [[json objectForKey:_KEY_ORIENTATION] integerValue];
        self.showStatusBar = [[json objectForKey:_KEY_SCREEN_MODE] boolValue];
        self.version = [NSString stringWithFormat:@"%@",[json objectForKey:_KEY_VERSION]];
        self.appID = [json objectForKey:_KEY_APP_ID];
        self.gameHash = [json objectForKey:_KEY_HASH];
//        self.icon = [GameListModel buildSmallIconURL:self.appID];
        self.name = [json objectForKey:_KEY_NAME];
//        self.url = [GameListModel buildGamePackageRequest:self.appID version:self.version];
        self.tags = [json objectForKey:_KEY_TAG];
        self.require = [json objectForKey:_KEY_REQUIRE];
    }
    return self;
}

- (BOOL)isInstalled {
    return _status == GAME_STATUS_INSTALLED;
}
@end
