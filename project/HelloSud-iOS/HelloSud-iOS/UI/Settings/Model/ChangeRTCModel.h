//
//  ChangeRTCModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/15.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangeRTCModel : BaseModel
@property(nonatomic, copy)NSString *title;
@property(nonatomic, assign)BOOL isSlect;
@property(nonatomic, assign)BOOL isClickable;

@end

NS_ASSUME_NONNULL_END
