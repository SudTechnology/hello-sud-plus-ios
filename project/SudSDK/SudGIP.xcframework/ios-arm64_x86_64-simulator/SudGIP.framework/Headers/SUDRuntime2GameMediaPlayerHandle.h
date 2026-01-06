//
//  SUDRuntime2GameMediaPlayerHandle.h
//  SudGIP
//
//  Created by kaniel on 10/18/25.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SUDRuntime2GameMediaPlayerHandle <NSObject>
- (UInt64)getInstanceID;

- (void)setMediaCAEAGLLayer:(CAEAGLLayer *) layer;
@end

NS_ASSUME_NONNULL_END

