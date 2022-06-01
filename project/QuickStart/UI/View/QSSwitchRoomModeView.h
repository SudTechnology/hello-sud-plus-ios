//
//  QSSwitchRoomModeView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"
#import "QSGameItemModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 房间模式切换
@interface QSSwitchRoomModeView : BaseView
typedef void(^OnTapGameCallBack)(QSGameItemModel *m);
@property (nonatomic, copy) OnTapGameCallBack onTapGameCallBack;

- (void)reloadData:(NSInteger)sceneType
            gameID:(int64_t)gameID
   isShowCloseGame:(BOOL)isShowCloseGame;
@end

NS_ASSUME_NONNULL_END
