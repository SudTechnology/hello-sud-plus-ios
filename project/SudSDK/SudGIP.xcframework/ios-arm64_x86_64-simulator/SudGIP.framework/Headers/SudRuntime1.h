//
//  SUDRuntime1.h
//  SudGIP
//
//  Created by kaniel on 10/18/25.
//

#import <Foundation/Foundation.h>
#import "ISudLogger.h"
#import "SUDRuntimeInitSDKParamModel.h"
#import "SUDRuntime1LoadGameParamModel.h"
#import "ISUDRuntime1GameHandle.h"
NS_ASSUME_NONNULL_BEGIN
/// Game Runtime1
@interface SUDRuntime1 : NSObject

/// Initialize the SDK
/// - Parameter paramModel: Required parameters
+(void)initSDK:(SUDRuntimeInitSDKParamModel *)paramModel
    completion:(nullable void(^)(NSError *_Nullable error))completion;

/// Reset the initialized SDK, called when SDK re-initialization is needed
+(void)uninitSDK;

/// Load game
/// @param paramModel Load parameters
/// @param progress Progress callback
/// @param completion Completion callback
+(void)loadGame:(SUDRuntime1LoadGameParamModel *)paramModel
       progress:(nullable void(^)(NSInteger progress))progress
     completion:(nullable void(^)(id<ISUDRuntime1GameHandle> _Nullable gameHandle, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
