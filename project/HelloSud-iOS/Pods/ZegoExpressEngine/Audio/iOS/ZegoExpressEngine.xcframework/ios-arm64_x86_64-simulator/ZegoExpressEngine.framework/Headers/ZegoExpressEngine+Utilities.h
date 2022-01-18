//
//  ZegoExpressEngine+Utilities.h
//  ZegoExpressEngine
//
//  Copyright © 2019 Zego. All rights reserved.
//

#import "ZegoExpressEngine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZegoExpressEngine (Utilities)

/// Start system performance monitoring.
///
/// Available since: 1.19.0
/// Description: Start system performance monitoring, monitor system or App's CPU usage and memory usage. Support set the monitoring interval.
/// Use cases: Monitor system performance can help user quickly locate and solve performance problems and improve user experience.
/// When to call: It needs to be called after [createEngine].
/// Restrictions: None.
/// Related callbacks: After starting monitoring, you can receive system performance status via [onPerformanceStatusUpdate] callback. [onPerformanceStatusUpdate] callback notification period is the value set by millisecond parameter.
/// Related APIs: Call [stopPerformanceMonitor] to stop system performance monitoring.
///
/// @param millisecond Monitoring time period(in milliseconds), the value range is [1000, 10000]. Default value is 2000 ms.
- (void)startPerformanceMonitor:(unsigned int)millisecond;

/// Stop system performance monitoring.
///
/// Available since: 1.19.0
/// Description: Stop system performance monitoring. After the monitoring is stopped, the [onPerformanceStatusUpdate] callback will not triggered.
/// Use cases: Monitor system performance can help user quickly locate and solve performance problems and improve user experience.
/// When to call: It needs to be called after [createEngine].
/// Restrictions: None.
/// Related APIs: Call [startPerformanceMonitor] to start system performance monitoring.
- (void)stopPerformanceMonitor;

/// Start network probe.
///
/// Available since: 2.3.0
/// Description: Some local network problems may cause audio and video calls to fail. Using this function to probe the network protocols, assist in locating and solving related network problems.
/// Use cases: Before pushing and pulling the stream, detect and locate some possible network problems.
/// When to call: It needs to be called after [createEngine].
/// Restrictions: The SDK will not perform multiple network probe at the same time, that is, if the network probe is in progress, the SDK will ignore subsequent calls of this function.
/// Caution: The SDK detects http, tcp, and udp in sequence internally. If the probe fails in the middle, the subsequent detection will not continue. Therefore, when reading the values ​​in the probe result, please pay attention to check if the value is nil. Network probe may take a long time. Developers can call [stopNetworkProbe] to stop network probe if needed. It is not recommended to start network probe during publishing/playing stream.
/// Related APIs: Call [stopNetworkProbe] to stop network probe.
///
/// @param config network probe config.
/// @param callback Network probe result callback.
- (void)startNetworkProbe:(ZegoNetworkProbeConfig *)config callback:(nullable ZegoNetworkProbeResultCallback)callback;

/// Stop network probe.
///
/// Available since: 2.3.0
/// Description: Stop network probe.
/// Use cases: Before pushing and pulling the stream, detect and locate some possible network problems.
/// When to call: It needs to be called after [createEngine].
/// Restrictions: None.
/// Related APIs: Call [startNetworkProbe] to start network probe.
- (void)stopNetworkProbe;

/// Start network speed test.
///
/// Available since: 1.20.0
/// Description: This function supports uplink/downlink network speed test.
/// Use cases: This function can be used to detect whether the network environment is suitable for pushing/pulling streams with specified bitrates.
/// When to call: It needs to be called after [createEngine], and before [startPublishingStream]. If you call [startPublishingStream] while speed testing, the speed test will automatically stop.
/// Restrictions: None.
/// Caution: Developers can register [onNetworkSpeedTestQualityUpdate] callback to get the speed test result, which will be triggered every 3 seconds. If an error occurs during the speed test process, [onNetworkSpeedTestError] callback will be triggered. If this function is repeatedly called multiple times, the last functioh call's configuration will be used.
/// Related APIs: Call [stopNetworkSpeedTest] to stop network speed test.
///
/// @param config Network speed test configuration.
- (void)startNetworkSpeedTest:(ZegoNetworkSpeedTestConfig *)config;

/// Start network speed test. Support set speed test interval。
///
/// Available since: 1.20.0
/// Description: This function supports uplink/downlink network speed test.
/// Use cases: This function can be used to detect whether the network environment is suitable for pushing/pulling streams with specified bitrates.
/// When to call: It needs to be called after [createEngine], and before [startPublishingStream]. If you call [startPublishingStream] while speed testing, the speed test will automatically stop.
/// Restrictions: None.
/// Caution: Developers can register [onNetworkSpeedTestQualityUpdate] callback to get the speed test result, which will be triggered every 3 seconds. If an error occurs during the speed test process, [onNetworkSpeedTestError] callback will be triggered. If this function is repeatedly called multiple times, the last functioh call's configuration will be used.
/// Related APIs: Call [stopNetworkSpeedTest] to stop network speed test.
///
/// @param config Network speed test configuration.
/// @param interval Interval of network speed test. In milliseconds, default is 3000 ms.
- (void)startNetworkSpeedTest:(ZegoNetworkSpeedTestConfig *)config interval:(unsigned int)interval;

/// Stop network speed test.
///
/// Available since: 1.20.0
/// Description: Stop network speed test.
/// Use cases: This function can be used to detect whether the network environment is suitable for pushing/pulling streams with specified bitrates.
/// When to call: It needs to be called after [createEngine].
/// Restrictions: None.
/// Caution: After the network speed test stopped, [onNetworkSpeedTestQualityUpdate] callback will not be triggered.
/// Related APIs: Call [startNetworkSpeedTest] to start network speed test.
- (void)stopNetworkSpeedTest;

/// Obtain synchronization network time information.
///
/// Available since: 2.9.0
/// Description: Obtain synchronization network time(NTP), including timestamp and maximum deviation.
/// Use cases: When performing multi-terminal synchronization behaviors, network time synchronization is required.
/// When to call: It needs to be called after [createEngine].
/// Restrictions: None.
- (ZegoNetworkTimeInfo *)getNetworkTimeInfo;

@end

NS_ASSUME_NONNULL_END
