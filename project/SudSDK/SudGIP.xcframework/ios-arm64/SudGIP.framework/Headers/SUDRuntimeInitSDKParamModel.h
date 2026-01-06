//
//  SUDRuntimeInitSDKParamModel.h
//  SudGIP
//
//  Created by kaniel on 10/18/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Initialization parameters
@interface SUDRuntimeInitSDKParamModel : NSObject

/// App ID
@property(nonatomic, strong) NSString *appId;
/// App Key
@property(nonatomic, strong) NSString *appKey;
/// User association authorization code
@property(nonatomic, strong) NSString *code;

@end

NS_ASSUME_NONNULL_END
