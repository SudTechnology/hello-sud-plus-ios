//
//  MGPlayerStateMapModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/19.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGPlayerStateMapModel : BaseModel
@property (nonatomic, strong) id model;
@property (nonatomic, copy) NSString *state;

@end

NS_ASSUME_NONNULL_END
