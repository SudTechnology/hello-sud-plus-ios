//
//  AudioMsgSystemModel.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/8.
//

#import "AudioMsgSystemModel.h"

@interface AudioMsgSystemModel(){
    NSAttributedString *_attrContent;
}
@property(nonatomic, copy)NSMutableAttributedString *content;
@end

@implementation AudioMsgSystemModel

+ (NSMutableArray *)mj_totalIgnoredPropertyNames {
    NSMutableArray *arr = NSMutableArray.new;
    [arr addObject:@"content"];
    [arr addObject:@"_attrContent"];
    [arr addObject:@"bgColor"];
    return arr;
}

/// 构建消息
/// @param content 消息内容
+ (instancetype)makeMsgWithAttr:(NSMutableAttributedString*)content {
    AudioMsgSystemModel *m = AudioMsgSystemModel.new;
    [m configBaseInfoWithCmd:CMD_CHAT_TEXT_NOTIFY];
    m.content = content;
    m.bgColor = [UIColor dt_colorWithHexString:@"#000000" alpha:0.3];
    return m;
}

/// 构建消息
/// @param content 消息内容
+ (instancetype)makeMsg:(NSString*)content {
    AudioMsgSystemModel *m = AudioMsgSystemModel.new;
    [m configBaseInfoWithCmd:CMD_CHAT_TEXT_NOTIFY];
    [m updateContent:content];
    m.bgColor = [UIColor dt_colorWithHexString:@"#000000" alpha:0.3];
    return m;
}

/// 设置内容
/// @param content 内容
- (void)updateContent:(NSString *)content {
    NSMutableAttributedString *attrMsg = [[NSMutableAttributedString alloc] initWithString:content];
    attrMsg.yy_lineSpacing = 6;
    attrMsg.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrMsg.yy_color = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
    self.content = attrMsg;
}

- (NSString *)cellName {
    return @"RoomSystemTableViewCell";
}

- (CGFloat)caculateHeight {
    CGFloat h = [super caculateHeight];
    CGFloat yMargin = 3;
    h += yMargin * 2;
    
    NSMutableAttributedString * attrMsg = [[NSMutableAttributedString alloc] init];
    if (self.content) {
        [attrMsg setAttributedString:_content];
    }
    _attrContent = attrMsg;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(MAX_CELL_CONTENT_WIDTH - 8, CGFLOAT_MAX) text:_attrContent];
    if (layout) {
        h += layout.textBoundingSize.height;
    }
    return h;
}

- (NSAttributedString *)attrContent {
    return _attrContent;
}

@end
