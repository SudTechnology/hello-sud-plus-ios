//
//  GameListModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 游戏模式
@interface HSGameModeModel : BaseModel

/// 游戏模式默认1
@property (nonatomic, assign) NSInteger mode;
/// 人数[在线，总人数]
@property (nonatomic, strong) NSArray<NSNumber *> *count;
@end

@interface HSGameItem: BaseModel
@property (nonatomic, assign) int64_t gameId;
@property (nonatomic, copy) NSString * gameName;
@property (nonatomic, copy) NSArray<NSNumber *> * suitScene;
@property (nonatomic, copy) NSString * gamePic;
@property (nonatomic, copy) NSString * homeGamePic;
@property (nonatomic, copy) NSString * leagueScenePic;
/// 是否是空白区域占位
@property (nonatomic, assign) BOOL isBlank;
/// 是否等待数据
@property (nonatomic, assign) BOOL isGameWait;
/// 业务需要 默认为0  1 = 关闭游戏 2 = 结束游戏
@property (nonatomic, assign) NSInteger itemType;

@property (nonatomic, strong) NSArray<HSGameModeModel *> * gameModeList;

/// 点单场景 --- 是否点中
@property (nonatomic, assign) BOOL isSelect;

@end
/// 列表场景model
@interface HSSceneModel: BaseModel
@property (nonatomic, assign) NSInteger sceneId;
@property (nonatomic, copy) NSString * sceneName;
@property (nonatomic, copy) NSString * sceneImage;
/// 新版本
@property (nonatomic, copy) NSString * sceneImageNew;
/// 是否等待数据
@property (nonatomic, assign) BOOL isGameWait;
/// 首个游戏
@property (nonatomic, strong)HSGameItem *firstGame;
/// 重用头id
- (NSString *)headIdentifier;
/// 重用cell
- (NSString *)reuseCell;
@end

/// 查询游戏列表Model
@interface GameListModel: BaseRespModel
@property (nonatomic, copy) NSArray<HSGameItem *>  * gameList;
@property (nonatomic, copy) NSArray<HSSceneModel *> * sceneList;

@end


NS_ASSUME_NONNULL_END
