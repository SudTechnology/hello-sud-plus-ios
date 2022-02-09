#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ISudFSMStateHandle <NSObject>
-(void) success:(NSString*) dataJson;
-(void) failure:(NSString*) dataJson;
@end

NS_ASSUME_NONNULL_END