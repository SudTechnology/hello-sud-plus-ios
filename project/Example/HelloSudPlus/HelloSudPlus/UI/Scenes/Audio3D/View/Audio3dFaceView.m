//
// Created by kaniel on 2023/8/4.
// Copyright (c) 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "Audio3dFaceView.h"
#import "Audio3dFaceItemModel.h"
#import "Audio3dFaceColCell.h"

@interface Audio3dFaceView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray<Audio3dFaceItemModel *> *dataList;
@end

@implementation Audio3dFaceView {

}

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.collectionView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(@0);
        make.bottom.equalTo(@(-kAppSafeBottom));
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    Audio3dFaceItemModel *itemModel0 = Audio3dFaceItemModel.new;
    itemModel0.name = @"dt_audio3d_face_light".dt_lan;
    itemModel0.icon = @"audio3d_face_light";
    itemModel0.faceId = 0;
    itemModel0.type = Audio3dFaceItemModelLight;
    // 1:跳舞 2:飞吻 3:感谢 4:鼓掌 5:害羞 6:欢呼 7:伤心 8:生气
    Audio3dFaceItemModel *itemModel1 = Audio3dFaceItemModel.new;
    itemModel1.name = @"dt_audio3d_face_dance".dt_lan;
    itemModel1.icon = @"audio3d_face_dance";
    itemModel1.faceId = 1;

    Audio3dFaceItemModel *itemModel2 = Audio3dFaceItemModel.new;
    itemModel2.name = @"dt_audio3d_face_kids".dt_lan;
    itemModel2.icon = @"audio3d_face_kids";
    itemModel2.faceId = 2;

    Audio3dFaceItemModel *itemModel3 = Audio3dFaceItemModel.new;
    itemModel3.name = @"dt_audio3d_face_tks".dt_lan;
    itemModel3.icon = @"audio3d_face_tks";
    itemModel3.faceId = 3;

    Audio3dFaceItemModel *itemModel4 = Audio3dFaceItemModel.new;
    itemModel4.name = @"dt_audio3d_face_clap".dt_lan;
    itemModel4.icon = @"audio3d_face_clap";
    itemModel4.faceId = 4;

    Audio3dFaceItemModel *itemModel5 = Audio3dFaceItemModel.new;
    itemModel5.name = @"dt_audio3d_face_shy".dt_lan;
    itemModel5.icon = @"audio3d_face_laugh";
    itemModel5.faceId = 5;

    Audio3dFaceItemModel *itemModel6 = Audio3dFaceItemModel.new;
    itemModel6.name = @"dt_audio3d_face_cheer".dt_lan;
    itemModel6.icon = @"audio3d_face_cheer";
    itemModel6.faceId = 6;

    Audio3dFaceItemModel *itemModel7 = Audio3dFaceItemModel.new;
    itemModel7.name = @"dt_audio3d_face_sad".dt_lan;
    itemModel7.icon = @"audio3d_face_sad";
    itemModel7.faceId = 7;

    Audio3dFaceItemModel *itemModel8 = Audio3dFaceItemModel.new;
    itemModel8.name = @"dt_audio3d_face_anger".dt_lan;
    itemModel8.icon = @"audio3d_face_anger";
    itemModel8.faceId = 8;
    self.dataList = @[itemModel0, itemModel1, itemModel2, itemModel3, itemModel4, itemModel5, itemModel6, itemModel7, itemModel8];

    [self.collectionView reloadData];
}

- (CGFloat)expectedHeight {
    CGFloat row = 2;//ceil(self.dataList.count / 4);
    return row * 82 + row * 20 + 20 + kAppSafeBottom;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Audio3dFaceColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Audio3dFaceColCell" forIndexPath:indexPath];
    Audio3dFaceColCell *c = (Audio3dFaceColCell *) cell;
    c.model = self.dataList[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    Audio3dFaceColCell *cell = (Audio3dFaceColCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell showSelectedAnimate];
    if (self.faceItemClickBlock) {
        self.faceItemClickBlock(self.dataList[indexPath.row]);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemW = 70;
    CGFloat itemH = 82;
    return CGSizeMake(itemW, itemH);
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 20;
        flowLayout.minimumInteritemSpacing = (kScreenWidth - 32 - 4 * 70) / 3;
        flowLayout.sectionInset = UIEdgeInsetsMake(20, 16, kAppSafeBottom, 16);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
        [_collectionView registerClass:[Audio3dFaceColCell class] forCellWithReuseIdentifier:@"Audio3dFaceColCell"];
    }
    return _collectionView;
}

@end
