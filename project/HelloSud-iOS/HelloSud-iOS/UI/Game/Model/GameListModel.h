//
//  GameListModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSGameItem: BaseModel
@property (nonatomic, assign) NSInteger gameId;
@property (nonatomic, copy) NSString * gameName;
@property (nonatomic, copy) NSArray<NSNumber *> * suitScene;
@property (nonatomic, copy) NSString * gamePic;
/// 是否是空白区域占位
@property (nonatomic, assign) BOOL isBlank;
/// 是否等待数据
@property (nonatomic, assign) BOOL isGameWait;
/// 业务需要 是否为语音房间
@property (nonatomic, assign) BOOL isAudioRoom;

@end
/// 列表场景model
@interface HSSceneModel: BaseModel
@property (nonatomic, assign) NSInteger sceneId;
@property (nonatomic, copy) NSString * sceneName;
@property (nonatomic, copy) NSString * sceneImage;
/// 是否等待数据
@property (nonatomic, assign) BOOL isGameWait;
@end

/// 查询游戏列表Model
@interface GameListModel: BaseRespModel
@property (nonatomic, copy) NSArray<HSGameItem *>  * gameList;
@property (nonatomic, copy) NSArray<HSSceneModel *> * sceneList;

@end


NS_ASSUME_NONNULL_END
