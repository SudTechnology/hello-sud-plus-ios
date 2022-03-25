//
//  AudioConfigModel.h
//  HelloSud-iOS
//
//  Created by Herbert on 2022/3/21.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioConfigModel : NSObject

@property(nonatomic, copy) NSString *appId;

@property(nonatomic, copy) NSString *appKey;

@property(nonatomic, copy) NSString *token;

@property(nonatomic, copy) NSString *userID;

@end


NS_ASSUME_NONNULL_END
