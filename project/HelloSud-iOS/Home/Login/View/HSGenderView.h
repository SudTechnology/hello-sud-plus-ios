//
//  HSGenderView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 性别选择View
@interface HSGenderView : BaseView

/// 点击回调
typedef void(^onSelectNodeBlock)(void);
@property (nonatomic, copy) onSelectNodeBlock selectBlock;

@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, copy) NSString *iconStr;
@property (nonatomic, assign) BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
