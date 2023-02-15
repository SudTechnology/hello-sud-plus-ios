//
//  EnterRoomModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseModel.h"


@class UserIndexInfo;

NS_ASSUME_NONNULL_BEGIN

/// pk结果房间信息
@interface PKResultRoomInfoModel : BaseModel
/// 房间id
@property(nonatomic, assign) int64_t roomId;
/// PK分数
@property(nonatomic, assign) NSInteger score;
/// 房主图像
@property(nonatomic, strong) NSString *roomOwnerHeader;
/// 房主昵称
@property(nonatomic, strong) NSString *roomOwnerNickname;
@end

/// pk结果房间信息
@interface PKResultModel : BaseModel

/// pk状态（1：待匹配 2：pk已匹配，未开始 3：k已匹配，已开始 4：pk匹配关闭 5：pk已结束）
@property(nonatomic, assign) NSInteger pkStatus;
/// 当前pkId值（有正在进行的PK则返回正在进行的pkId,否则返回null）
@property(nonatomic, assign) int64_t pkId;
/// 发起方用户信息
@property(nonatomic, strong) PKResultRoomInfoModel *srcRoomInfo;
/// 受邀方用户信息
@property(nonatomic, strong) PKResultRoomInfoModel *destRoomInfo;
/// PK剩余时间（单位：秒）
@property(nonatomic, assign) NSInteger remainSecond;

@end

/// 跨域匹配信息
@interface CrossAppMatchModel : BaseModel
/// 匹配状态(1未开启，2组队中，3匹配中)
@property (nonatomic, assign)NSInteger matchStatus;
/// 匹配选择的游戏ID
@property (nonatomic, assign)int64_t matchGameId;
/// 匹配的房间ID
@property (nonatomic, strong)NSString * matchRoomId;
/// 组ID
@property (nonatomic, strong)NSString *groupId;
/// 队长
@property (nonatomic, assign)int64_t captain;
/// 当前人数
@property (nonatomic, assign)NSInteger curNum;
/// 需匹配人数
@property (nonatomic, assign)NSInteger totalNum;
@property (nonatomic, strong)NSArray <UserIndexInfo *>*userList;
@end

/// 跨域房间信息
@interface CrossAppRoomModel : BaseModel
/// 组ID
@property (nonatomic, strong)NSString *roomId;
@property (nonatomic, strong)NSString * authSecret;
@end


/// 用户进入房间Model
@interface EnterRoomModel : BaseRespModel
@property(nonatomic, assign) NSInteger roomId;
@property(nonatomic, assign) NSInteger roomNumber;
@property(nonatomic, copy) NSString *roomName;
@property(nonatomic, assign) NSInteger gameId;
@property(nonatomic, assign) NSInteger memberCount;
@property(nonatomic, assign) NSInteger roleType;
@property(nonatomic, copy) NSString *rtcToken;
@property(nonatomic, copy) NSString *rtiToken;
@property(nonatomic, copy) NSString *imToken;
@property(nonatomic, assign) NSInteger gameLevel;
@property(nonatomic, assign) NSInteger sceneType;
/// pk当前状态信息
@property(nonatomic, strong) PKResultModel *pkResultVO;
/// 跨域信息
@property(nonatomic, strong) CrossAppMatchModel *extraMatchVO;
/// 跨域信息
@property(nonatomic, strong) CrossAppRoomModel *extraRoomVO;
/// 弹幕拉流ID
@property(nonatomic, copy) NSString *streamId;
/// 是否来自创建房间
@property(nonatomic, assign) BOOL isFromCreate;
@property(nonatomic, strong) NSMutableDictionary *dicExtData;
@end

NS_ASSUME_NONNULL_END
