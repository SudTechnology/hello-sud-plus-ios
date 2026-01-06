//
// Created by guanghui on 2022/7/5.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GameCheckoutStatus) {
    
    /** 等待执行 */
    GAME_CHECKOUT_WAITING,
    
    /** 开始执行 */
    GAME_CHECKOUT_STARTED,
    
    /** 下载中 */
    GAME_CHECKOUT_CHECKOUTING,
    
    /** 文件下载完成，校验文件完整性 */
    GAME_CHECKOUT_CHECK_FILE,
    
    /** 已暂停 */
    GAME_CHECKOUT_PAUSE,
    
    /** 已完成 */
    GAME_CHECKOUT_COMPLETED,
    
    /** 已取消 */
    GAME_CHECKOUT_CANCELED,
    
};
