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
@end

NS_ASSUME_NONNULL_END
