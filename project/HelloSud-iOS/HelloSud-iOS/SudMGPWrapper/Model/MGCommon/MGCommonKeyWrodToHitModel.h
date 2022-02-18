//
//  GameKeyWordHitModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 通用状态-游戏: 关键词状态   MG_COMMON_KEY_WORD_TO_HIT
@interface MGCommonKeyWrodToHitModel : NSObject
/// 单个关键词，兼容老版本
@property (nonatomic, copy) NSString *word;
/// 必填字段；关键词列表，可以传送多个关键词
@property (nonatomic, strong) NSArray<NSString *> *wordList;
/// 必填字段；关键词语言，默认:zh-CN(老版本游戏可能没有)；透传
@property (nonatomic, copy) NSString *wordLanguage;
/// 必填字段；text:文本包含匹配; number:数字等于匹配(必填字段)；默认:text(老版本游戏可能没有)；数字炸弹填number；透传
@property (nonatomic, copy) NSString *wordType;
/// 必填字段；false: 命中不停止；true:命中停止(必填字段)；默认:true(老版本游戏可能没有) 你演我猜填false；透传
@property (nonatomic, assign) BOOL isCloseConnHitted;
/// 必填字段，是否需要匹配关键字， 默认是true,   如果是false, 则只简单的返回语音识别文本；透传
@property (nonatomic, assign) BOOL enableIsHit;
/// 必填字段，是否需要返回转写文本，默认是true
@property (nonatomic, assign) BOOL enableIsReturnText;
@end

NS_ASSUME_NONNULL_END
