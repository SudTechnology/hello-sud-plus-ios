//
//  RespWebGameTokenModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2023/12/14.
//  Copyright © 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseRespModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RespWebGameTokenModel : BaseRespModel
@property(nonatomic, strong)NSString *token;
@property(nonatomic, strong)NSString *gameUrl;
/// 宽高缩放比
@property(nonatomic, assign)CGFloat scale;
@end

NS_ASSUME_NONNULL_END
