#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ISUDRuntime1GameStateHandle <NSObject>
-(void) success:(NSString*) dataJson;
-(void) failure:(NSString*) dataJson;
@end

NS_ASSUME_NONNULL_END
