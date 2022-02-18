//
//  MGCommonGameASRModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/18.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 通用状态-游戏: ASR状态(开启和关闭语音识别状态   MG_COMMON_GAME_ASR
@interface MGCommonGameASRModel : BaseModel
/// true:打开语音识别 false:关闭语音识别
@property (nonatomic, assign) BOOL isOpen;
/// 必填字段；关键词列表，可以传送多个关键词
@property (nonatomic, copy) NSArray <NSString *>*wordList;
/// 必填字段；关键词语言，默认:zh-CN(老版本游戏可能没有)；透传
@property (nonatomic, copy) NSString *wordLanguage;
/// 必填字段；text:文本包含匹配; number:数字等于匹配(必填字段)；默认:text(老版本游戏可能没有)；数字炸弹填number；透传
@property (nonatomic, copy) NSString *wordType;
/// 必填字段；false: 命中不停止；true:命中停止(必填字段)；默认:true(老版本游戏可能没有) 你演我猜填false；透传
@property (nonatomic, assign) BOOL isCloseConnHitted;
/// 必填字段；f必填字段，是否需要匹配关键字， 默认是true,   如果是false, 则只简单的返回语音识别文本；透传
@property (nonatomic, assign) BOOL enableIsHit;
/// 必填字段，是否需要返回转写文本，默认是true
@property (nonatomic, assign) BOOL enableIsReturnText;

@end

NS_ASSUME_NONNULL_END
