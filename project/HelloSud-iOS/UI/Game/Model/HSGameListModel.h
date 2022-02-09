//
//  HSGameListModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSGameList: BaseModel
@property (nonatomic, assign) NSInteger              gameId;
@property (nonatomic, copy) NSString              * gameName;
@property (nonatomic, copy) NSArray<NSNumber *>              * suitScene;
@property (nonatomic, copy) NSString              * gamePic;
/// 是否是空白区域占位
@property (nonatomic, assign) BOOL              isBlank;
/// 业务需要 是否为语音房间
@property (nonatomic, assign) BOOL              isAudioRoom;

@end

@interface HSSceneList: BaseModel
@property (nonatomic, assign) NSInteger              sceneId;
@property (nonatomic, copy) NSString              * sceneName;
@property (nonatomic, copy) NSString              * sceneImage;

@end

@interface HSGameListData: BaseModel
@property (nonatomic, copy) NSArray<HSGameList *>              * gameList;
@property (nonatomic, copy) NSArray<HSSceneList *>              * sceneList;

@end

/// 查询游戏列表Model
@interface HSGameListModel: HSBaseRespModel
@property (nonatomic, strong) HSGameListData              * data;

@end


NS_ASSUME_NONNULL_END
