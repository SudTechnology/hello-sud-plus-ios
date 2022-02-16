//
//  RoomNaviView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
/// 房间导航栏
@interface RoomNaviView : BaseView
//typedef void(^OnTapGameCallBack)(HSGameItem *m);
//@property (nonatomic, copy) OnTapGameCallBack onTapGameCallBack;
@property(nonatomic, copy)UIBUTTON_TAP_BLOCK closeTapBlock;
@property(nonatomic, copy)UIVIEW_TAP_BLOCK changeRoomTapBlock;
@property (nonatomic, strong) UILabel *roomNameLabel;
@end

NS_ASSUME_NONNULL_END
