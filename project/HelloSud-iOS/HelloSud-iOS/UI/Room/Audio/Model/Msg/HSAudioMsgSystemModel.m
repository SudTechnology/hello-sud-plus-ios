//
//  HSAudioMsgSystemModel.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/8.
//

#import "HSAudioMsgSystemModel.h"

@interface HSAudioMsgSystemModel(){
    NSAttributedString *_attrContent;
}

@end

@implementation HSAudioMsgSystemModel
/// 构建消息
/// @param msgModel 消息内容
/// @param language 语言
+ (instancetype)makeMsg:(GamePublicMsgModel *)msgModel language: (NSString *)language {
    HSAudioMsgSystemModel *m = HSAudioMsgSystemModel.new;
//    [m configBaseInfoWithCmd:CMD_PUBLIC_MSG_NTF];
//    m.content = content;
    m.msgModel = msgModel;
    m.language = language;
    return m;
}

- (NSString *)cellName {
    return @"HSRoomSystemTableViewCell";
}

- (CGFloat)caculateHeight {
    CGFloat h = [super caculateHeight];
    CGFloat yMargin = 3;
    h += yMargin * 2;
    
    NSMutableAttributedString * attrMsg = [[NSMutableAttributedString alloc] init];
    for (GamePublicMsg *m in self.msgModel.msg) {
        if (m.phrase == 2) {
            [attrMsg appendAttributedString:[AppUtil getAttributedStringWithString:m.user.name color:m.user.color]];
        } else if (m.phrase == 1) {
            NSString *textString = m.text.mj_keyValues[self.language];
            NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:textString];
            [attrMsg appendAttributedString:attributedString];
        }
    }
//    NSMutableAttributedString *attrMsg = [[NSMutableAttributedString alloc] initWithString:self.content];
    attrMsg.yy_lineSpacing = 6;
    attrMsg.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrMsg.yy_color = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    _attrContent = attrMsg;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(MAX_CELL_CONTENT_WIDTH - 8, CGFLOAT_MAX) text:attrMsg];
    if (layout) {
        h += layout.textBoundingSize.height;
    }
    return h;
}

- (NSAttributedString *)attrContent {
    return _attrContent;
}

@end
