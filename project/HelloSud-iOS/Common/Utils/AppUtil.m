//
//  AppUtil.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/18.
//

#import "AppUtil.h"

@implementation AppUtil

#pragma mark - 字典 json字符串互转
+ (NSString*)dictionaryToJson: (NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)turnStringToDictionary: (NSString *)turnString {
    NSData *turnData = [turnString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *turnDic = [NSJSONSerialization JSONObjectWithData:turnData options:NSJSONReadingMutableLeaves error:nil];
    return turnDic;
}

+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string color:(NSString*)color {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    /// todo
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor RW_colorWithHexString:color] range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}
@end
