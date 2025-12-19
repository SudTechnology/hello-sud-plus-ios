//
//  SudRtWrapperCalc.h
//  HelloSudPlus
//
//  Created by kaniel on 10/15/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// runtime 耗时分析
@interface SudRtWrapperCalc : NSObject
@property(nonatomic, strong)NSString *stepName;
- (void)begin;
- (void)end;
@end

NS_ASSUME_NONNULL_END
