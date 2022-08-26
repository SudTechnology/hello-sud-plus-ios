//
//  AppUtil.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppUtil : NSObject

/// 字典转JSON
/// @param dic 字典
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
/// JSON转字典
/// @param turnString JSON
+ (NSDictionary *)turnStringToDictionary:(NSString *)turnString;
/// 获取带颜色的NSMutableAttributedString
/// @param string string
/// @param color color
+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string color:(NSString*)color;

/// 当前APP window视图
+ (UIWindow *)currentWindow;
//获取当前最上层的控制器
+ (UIViewController *)currentViewController;

/// 复制内容到剪切板
/// @param content content
/// @param msg content
+ (void)copyToPasteProcess:(NSString *)content toast:(NSString *)msg;
@end

NS_ASSUME_NONNULL_END
