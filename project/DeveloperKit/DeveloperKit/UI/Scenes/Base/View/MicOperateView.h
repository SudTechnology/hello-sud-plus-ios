//
//  MicOperateView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 麦位操作
@interface MicOperateView : BaseView
@property(nonatomic, copy)StringBlock operateCallback;
@property(nonatomic, copy)UIBUTTON_TAP_BLOCK cancelCallback;

/// 初始化操作列表
/// @param list 操作列表名称
- (instancetype)initWithOperateList:(NSArray<NSString *>*)list;
@end

NS_ASSUME_NONNULL_END
