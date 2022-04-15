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
typedef void(^OnTapGameCallBack)(HSGameItem *m);
@property (nonatomic, copy) OnTapGameCallBack onTapGameCallBack;

- (void)reloadData:(NSInteger)sceneType gameID:(NSInteger)gameID;
@end

NS_ASSUME_NONNULL_END
