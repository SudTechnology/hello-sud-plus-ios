//
//  ModelAiRoomOperatorView.h
//  HelloSudPlus
//
//  Created by kaniel on 9/7/24.
//  Copyright © 2024 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RoomOperatorView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ModelAiRoomOperatorView : RoomOperatorView
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UILabel *recordLabel;
@property(nonatomic, strong)void(^recordTouchDownBlock)(void);
@property(nonatomic, strong)void(^recordTouchUpBlock)(void);
@end

NS_ASSUME_NONNULL_END
