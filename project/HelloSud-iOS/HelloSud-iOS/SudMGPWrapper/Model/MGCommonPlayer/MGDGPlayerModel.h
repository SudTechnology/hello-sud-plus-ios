//
//  MGDGPlayerModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/18.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 你画我猜: 选词中  MG_DG_SELECTING
@interface MGDGSelectingModel : BaseModel
/// bool 类型 true：正在选词中，false: 不在选词中
@property (nonatomic, assign) BOOL isSelecting;
@end


#pragma mark - 你画我猜: 作画中状态  MG_DG_PAINTING
@interface MGDGPaintingModel : BaseModel
/// true: 绘画中，false: 取消绘画
@property (nonatomic, assign) BOOL isPainting;
@end


#pragma mark - 你画我猜: 显示错误答案状态  MG_DG_ERRORANSWER
@interface MGDGErrorAnswerModel : BaseModel
// 字符串类型，展示错误答案
@property (nonatomic, copy) NSString *msg;
@end


#pragma mark - 你画我猜: 显示总积分状态  MG_DG_TOTALSCORE
@interface MGDGTotalScoreModel : BaseModel
/// 字符串类型 总积分
@property (nonatomic, copy) NSString *msg;
@end


#pragma mark - 你画我猜: 本次获得积分状态  MG_DG_SCORE
@interface MGDGScoreModel : BaseModel
/// 字符串类型 展示本次获得积分
@property (nonatomic, copy) NSString *msg;
@end

NS_ASSUME_NONNULL_END
