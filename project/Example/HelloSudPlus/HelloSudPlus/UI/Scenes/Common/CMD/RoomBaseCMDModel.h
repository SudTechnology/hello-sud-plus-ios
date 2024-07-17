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
@property(nonatomic, assign) NSInteger cmd;

/// 发送者信息
@property(nonatomic, strong) AudioUserModel *sendUser;

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

/// 解码服务器返回的model
/// @param keyValues keyValues json对象
+ (instancetype)fromServerJSON:(NSString *)keyValues;

/// 解码服务器返回的model
/// @param keyValues keyValues json对象
+ (id)parseInstance:(Class)cls fromServerJSON:(NSString *)keyValues;
@end

/// 跨房PK游戏结果指令 model
@interface RoomGameMonopolyCardGiftNotifyCMDModel : RoomBaseCMDModel
@property(nonatomic, assign) NSInteger type;// 1: 重摇卡， 2：免租卡， 3：指定点数卡
@property(nonatomic, assign) NSInteger senderUid;// 发送者uid
@property(nonatomic, assign) NSArray<NSNumber *> *receiverUidList;// 接收者用户id列表
@property(nonatomic, assign) NSInteger amount;
@end

/// 游戏道具卡送礼通知 model
@interface RoomGamePropsCardGiftNotifyCMDModel : RoomBaseCMDModel
@property(nonatomic, strong) NSString * paidEventType;// specify_dice_roll
@property(nonatomic, assign) NSInteger senderUid;// 发送者uid
@property(nonatomic, assign) NSArray<NSNumber *> *receiverUidList;// 接收者用户id列表
@property(nonatomic, assign) NSInteger amount;
@end

NS_ASSUME_NONNULL_END
