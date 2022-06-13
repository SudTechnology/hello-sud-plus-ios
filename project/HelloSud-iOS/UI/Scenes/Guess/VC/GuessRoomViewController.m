//
// Created by kaniel on 2022/6/1.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GuessRoomViewController.h"
#import "GuessMineView.h"

@interface GuessRoomViewController()
@property (nonatomic, strong)GuessMineView *guessMineView;
@end

@implementation GuessRoomViewController {

}

- (Class)serviceClass {
    return GuessService.class;
}


- (void)dtAddViews {
    [super dtAddViews];
    [self.sceneView addSubview:self.guessMineView];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    CGFloat bottom = kAppSafeBottom + 51;
    [self.guessMineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-18));
        make.width.equalTo(@80);
        make.height.equalTo(@90);
        make.bottom.equalTo(@(-bottom));
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];

}

- (void)dtUpdateUI {
    [super dtUpdateUI];

}

- (void)dtConfigEvents {
    [super dtConfigEvents];

}

- (GuessMineView *)guessMineView {
    if (!_guessMineView) {
        _guessMineView = [[GuessMineView alloc] init];
    }
    return _guessMineView;
}
@end
