//
//  ReqAppWebGameTokenModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2023/12/14.
//  Copyright © 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 请求webgame token参数
@interface ReqAppWebGameTokenModel : NSObject
@property(nonatomic, strong)NSString *gameId;
@property(nonatomic, strong)NSString *roomId;
@end

NS_ASSUME_NONNULL_END
