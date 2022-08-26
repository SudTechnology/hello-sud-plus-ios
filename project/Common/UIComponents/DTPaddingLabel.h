//
//  DTPaddingLabel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTPaddingLabel : UILabel
/// 两边间距 自动布局时计算
@property (nonatomic, assign) CGFloat paddingX;
/// 将paddingX使用在固定的宽度的情况下，默认NO
@property (nonatomic, assign) BOOL isPaddingXUseForFixedWidth;
@end

NS_ASSUME_NONNULL_END
