//
//  HSSettingModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 设置model
@interface HSSettingModel : BaseModel
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *subTitle;
/// 是否有更多
@property(nonatomic, assign)BOOL isMore;
@property(nonatomic, copy)NSString *pageURL;
@end

NS_ASSUME_NONNULL_END
