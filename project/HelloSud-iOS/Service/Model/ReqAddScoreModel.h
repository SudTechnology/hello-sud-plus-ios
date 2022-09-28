//
//  ReqAddScoreModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/9/26.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReqAddScoreModel : NSObject
@property(nonatomic, strong)NSString *mgId;
@property(nonatomic, strong)NSString *roomId;
@property(nonatomic, strong)NSString *roundId;
/// 本人当前积分
@property(nonatomic, assign) NSInteger lastRoundScore;
/// 充值积分
@property(nonatomic, assign) NSInteger incrementalScore;
/// 充值后总积分
@property(nonatomic, assign) NSInteger totalScore;
@end

NS_ASSUME_NONNULL_END
