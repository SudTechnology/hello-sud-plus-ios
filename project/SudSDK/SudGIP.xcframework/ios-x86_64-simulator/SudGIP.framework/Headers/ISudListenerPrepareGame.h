#import <Foundation/Foundation.h>
#import "GameCheckoutStatus.h"

NS_ASSUME_NONNULL_BEGIN


@protocol ISudListenerPrepareGame <NSObject>

-(void) onPrepareSuccess:(int64_t) mgId;

-(void) onPrepareFailure:(int64_t) mgId errCode:(int) errCode errMsg:(NSString *) errMsg;

-(void) onPrepareStatus:(int64_t) mgId checkoutedSize:(long) checkoutedSize totalSize:(long) totalSize status:(GameCheckoutStatus) status;

@end

NS_ASSUME_NONNULL_END
