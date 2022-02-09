#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ISudListenerInitSDK.h"
#import "ISudListenerGetMGList.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ISudFSTAPP;
@protocol ISudFSMMG;

@interface SudMGP : NSObject
+ (NSString*_Nullable) getVersion;

+ (void) initSDK:(NSString*_Nullable) appId appKey:(NSString*_Nullable) appKey isTestEnv:(BOOL) isTestEnv listener:(ISudListenerInitSDK _Nullable ) listener;

+ (void) getMGList:(ISudListenerGetMGList _Nullable ) listener;

+ (id<ISudFSTAPP>_Nonnull)loadMG:(NSString*_Nullable)userId roomId:(NSString*_Nullable)roomId code:(NSString*_Nullable)code mgId:(int64_t) mgId language:(NSString*_Nullable)language fsmMG:(id<ISudFSMMG>_Nonnull)fsmMG rootView:(UIView*_Nullable)rootView;

+ (bool) destroyMG:(id<ISudFSTAPP>_Nullable) fstAPP;

+ (void) setLogLevel:(int) logLevel;
@end

NS_ASSUME_NONNULL_END
