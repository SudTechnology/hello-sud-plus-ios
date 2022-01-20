//
//  FsmAppToMgManager.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/19.
//

#import <Foundation/Foundation.h>
/// SudMGPSDK
#import <SudMGP/ISudFSMMG.h>
#import <SudMGP/ISudFSTAPP.h>
#import <SudMGP/SudMGP.h>
#import <SudMGP/ISudFSMStateHandle.h>

#import "AppUtil.h"
#import "GameConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface FsmAppToMgManager : NSObject
@property (nonatomic, weak) id<ISudFSTAPP> fsmAPP2MG;
- (instancetype)init:(id<ISudFSTAPP>)fsmAPP2MG;
@end

NS_ASSUME_NONNULL_END
