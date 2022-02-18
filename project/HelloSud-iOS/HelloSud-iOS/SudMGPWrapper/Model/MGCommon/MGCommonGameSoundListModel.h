//
//  MGCommonGameSoundListModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/18.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 通用状态-游戏: 游戏上报游戏中的声音列表   MG_COMMON_GAME_SOUND_LIST
@interface MGCommonGameSoundList : BaseModel
/// 声音资源的名字
@property (nonatomic, copy) NSString *name;
/// 声音资源的URL链接
@property (nonatomic, copy) NSString *url;
/// 声音资源类型
@property (nonatomic, copy) NSString *type;

@end

@interface MGCommonGameSoundListModel : BaseModel
@property (nonatomic, copy) NSArray<MGCommonGameSoundList *> *list;

@end

NS_ASSUME_NONNULL_END
