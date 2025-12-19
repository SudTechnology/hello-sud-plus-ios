//
//  QsrCommon.h
//  QuickStart-Runtime
//
//  Created by kaniel on 12/4/25.
//

#import <Foundation/Foundation.h>
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <SudGIP/SudGIP-umbrella.h>

#define SUDMGP_APP_ID   @"1461564080052506636"
#define SUDMGP_APP_KEY  @"03pNxK2lEXsKiiwrBQ9GbH541Fk2Sfnc"

/// weakself宏
#define WeakSelf __weak typeof(self) weakSelf = self;

NS_ASSUME_NONNULL_BEGIN

@interface QsrCommon : NSObject
@property(nonatomic, strong)NSString *userId;
+(instancetype)shared;
- (void)reqGetCode:(void(^)(NSString *code))success fail:(void(^)(NSInteger code, NSString *msg))fail;
@end

NS_ASSUME_NONNULL_END
