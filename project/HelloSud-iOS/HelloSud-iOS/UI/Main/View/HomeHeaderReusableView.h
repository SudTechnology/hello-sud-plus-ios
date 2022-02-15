//
//  HomeHeaderReusableView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "BaseCollectionReusableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeHeaderReusableView : BaseCollectionReusableView
@property (nonatomic, strong) NSArray <HSGameList *> *headerGameList;
@property (nonatomic, strong) HSSceneList *sceneModel;
@end

NS_ASSUME_NONNULL_END
