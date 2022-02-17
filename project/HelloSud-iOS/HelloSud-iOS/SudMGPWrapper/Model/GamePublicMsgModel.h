//
//  GamePublicMsgModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/19.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

/// 公屏消息Model
@interface GamePublicText :NSObject
@property (nonatomic, copy) NSString *def;
@property (nonatomic, copy) NSString *en_GB;
@property (nonatomic, copy) NSString *en_US;
@property (nonatomic, copy) NSString *ms_BN;
@property (nonatomic, copy) NSString *ms_MY;
@property (nonatomic, copy) NSString *zh_CN;
@property (nonatomic, copy) NSString *zh_HK;
@property (nonatomic, copy) NSString *zh_MO;
@property (nonatomic, copy) NSString *zh_SG;
@property (nonatomic, copy) NSString *zh_TW;
@end

@interface GamePublicUser :NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *color;
@end

@interface GamePublicMsg :NSObject
@property (nonatomic, assign) long phrase;
@property (nonatomic, strong) GamePublicText *text;
@property (nonatomic, strong) GamePublicUser *user;

@end

@interface GamePublicMsgModel : NSObject
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSArray<GamePublicMsg *> *msg;
@end

NS_ASSUME_NONNULL_END
