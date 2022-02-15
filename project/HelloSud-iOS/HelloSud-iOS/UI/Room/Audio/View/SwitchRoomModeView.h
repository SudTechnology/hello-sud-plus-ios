//
//  SwitchRoomModeView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
/// 房间模式切换
@interface SwitchRoomModeView : BaseView
typedef void(^OnTapGameCallBack)(HSGameList *m);
@property (nonatomic, copy) OnTapGameCallBack onTapGameCallBack;

@end

NS_ASSUME_NONNULL_END
