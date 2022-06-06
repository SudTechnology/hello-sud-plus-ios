//
//  HomeHeaderReusableView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "BaseCollectionReusableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeHeaderReusableView : BaseCollectionReusableView
@property (nonatomic, strong) NSArray <HSGameItem *> *headerGameList;
@property (nonatomic, strong) HSSceneModel *sceneModel;
@property (nonatomic, copy) UIBUTTON_TAP_BLOCK customBlock;
@property (nonatomic, copy) UIBUTTON_TAP_BLOCK moreGuessBlock;
@end

NS_ASSUME_NONNULL_END
