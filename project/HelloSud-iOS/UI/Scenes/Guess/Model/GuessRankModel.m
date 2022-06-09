//
//  GuessRankModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GuessRankModel.h"

@implementation GuessRankModel
+ (GuessRankModel *)createModel:(NSInteger)rank count:(NSInteger)count name:(NSString *)name avatar:(NSString *)avatar {
    GuessRankModel *m = [[GuessRankModel alloc]init];
    m.rank = rank;
    m.count = count;
    m.name = name;
    m.avatar = avatar;
    return m;
}
@end
