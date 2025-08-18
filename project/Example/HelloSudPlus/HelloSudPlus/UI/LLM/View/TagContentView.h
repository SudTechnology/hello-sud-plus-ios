//
//  TagContentView.h
//  HelloSudPlus
//
//  Created by kaniel on 7/1/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
/// 标签内容视图
@interface TagContentView : BaseView
@property(nonatomic, strong)void(^clickTagBlock)(NSArray *tagList);
@property(nonatomic, assign)NSInteger limitLines;// 限制行数
@property(nonatomic, strong)NSArray<NSString *> *defaultSelectedList;
- (void)updateTagList:(NSArray<NSString *> *)tagList contentWidth:(CGFloat)contentWidth;
@end

NS_ASSUME_NONNULL_END
