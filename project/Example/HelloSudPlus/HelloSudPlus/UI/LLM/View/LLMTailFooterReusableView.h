//
//  LLMTailFooterReusableView.h
//  HelloSudPlus
//
//  Created by kaniel on 6/23/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HomeFooterReusableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLMTailFooterReusableView : HomeFooterReusableView
@property(nonatomic, weak)UICollectionView *colView;
- (CGFloat)perferHeight;
@end

NS_ASSUME_NONNULL_END
