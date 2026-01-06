//
//  SUDRuntime2LoadPackageParamModel.h
//  SudGIP
//
//  Created by kaniel on 10/18/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Parameters for loading the game
@interface SUDRuntime1LoadGameParamModel : NSObject

/// Game ID - SUD platform or custom xxxx
@property(nonatomic, strong) NSString *gameId;
/// Game version - e.g., 1.0.0
@property(nonatomic, strong) NSString *version;
/// Game package address - Remote URL or local path
@property(nonatomic, strong) NSString *path;

@end

NS_ASSUME_NONNULL_END
