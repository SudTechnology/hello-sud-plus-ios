#!/bin/sh
# Localizable.strings文件路径
localizableFile="${PWD}/HelloSud-iOS/App/en.lproj/Localizable.strings"
# 生成的oc文件路径（根据个人习惯修改）
localizedFile_h="${PWD}/HelloSud-iOS/Service/Common/LocalizedService.h"
localizedFile_m="${PWD}/HelloSud-iOS/Service/Common/LocalizedService.m"

# m文件
# 将localizable.strings中的文本转为swift格式的常量，存入一个临时文件
sed "s/^\"\([a-zA-Z|(_)]*\).*/+ (NSString *)\1 { return @\"\1\".localized; }/g" "${localizableFile}" > "${localizedFile_m}.tmp"
# 先将localized作为计算属性输出到目标文件
echo "#import \"LocalizedService.h\"\n\n @implementation NSString(Localized)\n- (NSString *)localized {\n    NSBundle *bundle = NSBundle.currentLanguageBundle;
    NSString *result = nil;
    if (bundle) {
        result = [bundle localizedStringForKey:self value:self table:nil];
        if (![self isEqualToString:result]) {
            return result;
        }
        if (NSBundle.defaultLanguageBundle) {
            return [NSBundle.defaultLanguageBundle localizedStringForKey:self value:self table:nil];
        }
    }
    return NSLocalizedString(self, comment: self); \n}" > "${localizedFile_m}"

# h文件
# 将localizable.strings中的文本转为swift格式的常量，存入一个临时文件
sed "s/^\"\([a-zA-Z|(_)]*\).*/+ (NSString *)\1;/g" "${localizableFile}" > "${localizedFile_h}.tmp"
echo "#import <Foundation/Foundation.h>\n\nNS_ASSUME_NONNULL_BEGIN \n@interface NSString(Localized)\n- (NSString *)localized;" > "${localizedFile_h}"


# 再将临时文件中的常量增量输出到目标文件
cat "${localizedFile_m}.tmp" >> "${localizedFile_m}"
cat "${localizedFile_h}.tmp" >> "${localizedFile_h}"
# 最后增量输出一个"}"到目标文件，完成输出
echo "\n@end\nNS_ASSUME_NONNULL_END" >> "${localizedFile_h}"
echo "\n@end" >> "${localizedFile_m}"

# 删除临时文件
rm "${localizedFile_m}.tmp"
rm "${localizedFile_h}.tmp"
