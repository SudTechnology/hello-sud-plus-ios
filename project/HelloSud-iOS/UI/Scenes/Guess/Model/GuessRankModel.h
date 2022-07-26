//
//  GuessRankModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 排行榜数据
@interface GuessRankModel : BaseModel
@property (nonatomic, assign)NSInteger rank;
@property (nonatomic, assign)NSInteger count;
@property (nonatomic, strong)NSString * name;
@property (nonatomic, strong)NSString * avatar;
@property (nonatomic, strong)NSString * tip;
@property (nonatomic, strong)NSString * subTitle;

+ (GuessRankModel *)createModel:(NSInteger)rank count:(NSInteger)count name:(NSString *)name avatar:(NSString *)avatar tip:(NSString *)tip subTitle:(NSString *)subTitle;
@end

NS_ASSUME_NONNULL_END
