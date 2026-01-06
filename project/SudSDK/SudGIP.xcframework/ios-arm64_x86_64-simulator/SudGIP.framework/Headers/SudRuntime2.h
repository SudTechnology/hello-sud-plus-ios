//
//  SUDRuntime2.h
//  SudGIP
//
//  Created by kaniel on 10/18/25.
//

#import <Foundation/Foundation.h>
#import "ISudLogger.h"
#import "SUDRuntimeInitSDKParamModel.h"
#import "SUDRuntime2LoadPackageParamModel.h"
#import "SUDRuntime2GameRuntime.h"
#import "SUDRuntime2GameMediaPlayerHandle.h"
#import "SUDRuntime2GameAudioSession.h"
NS_ASSUME_NONNULL_BEGIN

/// Game SUDRuntime2
@interface SUDRuntime2 : NSObject

/// Initialize the SDK
/// - Parameter paramModel: Required parameters
/// - Parameter completion: completion description
+(void)initSDK:(SUDRuntimeInitSDKParamModel *)paramModel
    completion:(nullable void(^)(NSError *_Nullable error))completion;

/// Reset the initialized SDK, called when SDK re-initialization is needed
+(void)uninitSDK;

/// Create a runtime instance (single process has only one)
/// @param options Optional configuration parameters for the runtime
/// @param completion Completion callback
+(void)createRuntime:(NSDictionary *_Nullable)options
          completion:(nullable void(^)(id<SUDRuntime2GameRuntime> _Nullable runtime, NSError *_Nullable error))completion;

/// Load game package
/// @param paramModel Load parameters
/// @param progress Progress callback
/// @param completion Completion callback
+(void)loadPackage:(SUDRuntime2LoadPackageParamModel *)paramModel
       progress:(nullable void(^)(NSInteger progress))progress
     completion:(nullable void(^)(NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
