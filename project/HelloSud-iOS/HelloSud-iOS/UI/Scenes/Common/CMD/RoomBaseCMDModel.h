//
//  RoomBaseCMDModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import <Foundation/Foundation.h>
#import "AudioUserModel.h"
#import "RoomCmd.h"
NS_ASSUME_NONNULL_BEGIN
/// 最大cell内容宽度
#define MAX_CELL_CONTENT_WIDTH 260

/// 语音房消息基类model
@interface RoomBaseCMDModel : BaseModel

/// 指令值
@property(nonatomic, assign)NSInteger cmd;

/// 发送者信息
@property(nonatomic, strong)AudioUserModel *sendUser;

/// 获取model对应cell名称
- (NSString *)cellName;

/// cell高度
- (CGFloat)cellHeight;

/// 计算cell高度，子类覆盖返回
- (CGFloat)caculateHeight;

/// 触发计算属性
- (void)prepare;
/// 配置消息
/// @param cmd 消息指令
- (void)configBaseInfoWithCmd:(NSInteger)cmd;

/// 解码model
/// @param keyValues keyValues json对象
+ (instancetype)fromJSON:(id)keyValues;
@end

NS_ASSUME_NONNULL_END
