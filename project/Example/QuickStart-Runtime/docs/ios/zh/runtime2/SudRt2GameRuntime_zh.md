# SudRt2GameRuntime API 说明

`SudRt2GameRuntime` 是在 Runtime 中实现的、定义了应用层如何管理游戏相关内容的功能接口类。此接口的实例在同一个进程中应只有一个，由 `SudRt2GameRuntime` 创建。

## 小游戏运行环境的创建步骤

1. 调用 `SudRt2GameRuntime` 的 `createGameHandleWithOptions:completion:` 创建小游戏运行环境

## Runtime Game API

下列函数、接口、常量等定义如果没有特别标明所在的类，则属于类 `SudRt2GameRuntime`。

### createRuntimeWithOptions:completion:

```objc
+ (void)createRuntimeWithOptions:(NSDictionary *)options
                      completion:(nullable void (^)(id<SudRt2GameRuntime> _Nullable runtime,
                                                    NSError * _Nullable error))completion
```

创建实现了 `SudRt2GameRuntime` 功能接口的实例。

应用层应持有 `SudRt2GameRuntime` 的实例，当不再需要时持有实例的变量设置为 `nil`。

应用层同时只应使用一个 `SudRt2GameRuntime` 的实例。

**_参数_**

- NSDictionary \*options: Runtime 初始化参数， 详见下表
- void (^completion)(id<SudRt2GameRuntime> \_Nullable runtime, NSError \* \_Nullable error): 创建结果回调

**_Runtime 初始化参数_**

| 属性                                    | 数据类型 | 是否必填 | 默认值                                                                   | 说明                      | 支持版本 |
| :-------------------------------------- | :------- | :------- | :----------------------------------------------------------------------- | :------------------------ | :------- |
| SUD_RT2_KEY_RUNTIME_ASSETS_PATH         | NSString | 否       | [NSBundle bundleForClass:[CRGameSystem class]] + "default-assets.bundle" | Core 使用的资源所在的路径 |
| SUD_RT2_KEY_RUNTIME_STORAGE_PATH_APP    | NSString | 否       | NSCachesDirectory + "/app"                                               | 小游戏包安装目录          |          |
| SUD_RT2_KEY_RUNTIME_STORAGE_PATH_CACHE  | NSString | 否       | NSTemporaryDirectory                                                     | 运行时临时存储目录        |          |
| SUD_RT2_KEY_RUNTIME_STORAGE_PATH_USER   | NSString | 否       | NSCachesDirectory + "/user"                                              | 玩家数据目录              |          |
| SUD_RT2_KEY_RUNTIME_STORAGE_PATH_PLUGIN | NSString | 否       | NSCachesDirectory + "/plugin"                                            | 小游戏插件目录            |          |

**_回调参数说明_**

| 回调                                                                                      | 回调参数                                                     | 说明             |
| :---------------------------------------------------------------------------------------- | :----------------------------------------------------------- | :--------------- |
| void (^completion)(id<SudRt2GameRuntime> \_Nullable runtime, NSError \* \_Nullable error) | **runtime**: 已初始化的 Runtime 实例<br/>**error**: 错误信息 | 初始化成功后回调 |

## Runtime APIs

下列函数、接口、常量等定义如果没有特别标明所在的类，则属于类 `SudRt2GameRuntime`。

### cancelCleanUp

```objc
- (void)cancelCleanUp
```

取消清除过期临时文件任务

### cleanUpExpiredTemporaryFiles

```objc
- (void)cleanUpExpiredTemporaryFiles:(NSInteger)keepTimeInMinute
                               start:(nullable void (^)(void))start
                            progress:(nullable void (^)(NSString *path, NSError * _Nullable error))progress
                          completion:(nullable void (^)(NSError * _Nullable error))completion
```

清除过期临时文件

**_参数_**

- NSInteger keepTimeInMinute: 临时文件保留时间，单位为分钟。如果当前时间减去文件最后一次访问时间大于文件保留时间，则删除此文件
- void (^start)(void): 开始清理回调
- void (^progress)(NSString _path, NSError _ \_Nullable error): 清理过程回调
- void (^completion)(NSError \* \_Nullable error): 清理完成回调

**_回调参数说明_**

| 回调                                                         | 回调参数                                                                        | 说明           |
| :----------------------------------------------------------- | :------------------------------------------------------------------------------ | :------------- |
| void (^start)(void)                                          | -                                                                               | 开始清除时回调 |
| void (^progress)(NSString _path, NSError _ \_Nullable error) | **path**: <br/>文件或文件夹的绝对路径<br/>**error**: 错误信息，删除成功为 `nil` | 清除过程回调   |
| void (^completion)(NSError \* \_Nullable error)              | **error**: 错误信息                                                             | 清除完成后回调 |

### createGameHandleWithOptions:completion:

```objc
- (void)createGameHandleWithOptions:(NSDictionary *)options
                         completion:(nullable void (^)(id<SudRt2GameRuntime> _Nullable handle,
                                                       NSError * _Nullable error))completion
```

创建游戏运行环境实例。

目前 Runtime 只支持一个进程一个游戏运行环境实例，如果需要重用实例可类似如下操作:

```objc
[gameHandle destroy];
...//other operation
[gameHandle setGameStartOptions];
...//other operation
[gameHandle start];
```

**_参数_**

- NSDictionary \*options: GameHandle 创建参数
- void (^completion)(id<SudRt2GameRuntime> \_Nullable handle, NSError \* \_Nullable error): 创建结果回调

**_GameHandle 创建参数_**

| 属性                                      | 数据类型  | 是否必填 | 默认值                                  | 说明                                                                                                                | 支持版本 |
| :---------------------------------------- | :-------- | :------- | :-------------------------------------- | :------------------------------------------------------------------------------------------------------------------ | :------- |
| SUD_RT2_KEY_GAME_USER_ID                  | NSString  | 是       |                                         | 玩家唯一标识字符串，Runtime 会给每个玩家保存一份游戏数据，不同玩家的游戏数据互相隔离                                |
| SUD_RT2_KEY_GAME_HTTP_CACHE_LIMIT_STORAGE | NSInteger | 否       | 200                                     | HTTP 响应缓存大小上限，单位：MB；有效的缓存大小是一个大于 0 的整数                                                  |
| SUD_RT2_KEY_GAME_HTTP_CACHE_PATH          | NSString  | 否       | /Library/Caches/(application bundle id) | HTTP 响应缓存路径，该路径为相对路径。存储数据的完整路径为 /Library/Caches/(application bundle id)/(your cache path) |

**_回调参数说明_**

| 回调                                                                                     | 回调参数                                             | 说明           |
| :--------------------------------------------------------------------------------------- | :--------------------------------------------------- | :------------- |
| void (^completion)(id<SudRt2GameRuntime> \_Nullable handle, NSError \* \_Nullable error) | **handle**: 游戏运行环境实例<br/>**error**: 错误信息 | 创建完成后回调 |

### getManagerWithName:options:

```objc
- (NSObject *)getManagerWithName:(NSString *)name
                         options:(NSDictionary *)options
```

获取指定名称对应的管理器实例。

每个管理器实例在一个 Runtime 实例中只有一个。

**_参数_**

- NSString \*name: 要获取的管理器的名称，合法的管理器名称见下表
- NSDictionary \*options: 可选参数，目前只支持 `nil`

**_合法的管理器名称_**

| 名称 | 对应的接口类 | 说明 |
| :--- | :----------- | :--- |

无

**_返回值_**

如果传入合法管理器名称，则返回管理器 `NSObject` 类型的实例，否则返回 `nil`。

`NSObject` 类型的返回值需要转为对应的接口类型才能正常使用，不同管理器对应的接口类见上表。

### getRuntimeDesc

```objc
+ (NSString *)getRuntimeDesc
```

返回 Runtime SDK 模块的版本描述

返回供人阅读的一些版本相关信息，可能为:

1. 版本开发阶段：alpha、beta、RC、release 等
2. 版本发布日期
3. 其它描述信息

此版本信息不应用于版本兼容性判断。

### getRuntimeFeatures

```objc
+ (NSArray<NSString *> *)getRuntimeFeatures
```

返回 Runtime 支持的特性。

此 API 主要用来进行判断 Runtime 功能的兼容性。

### getRuntimeVersion

```objc
+ (NSString *)getRuntimeVersion
```

返回 Runtime SDK 模块的版本号

返回形如: **主版本号.次版本号.修订号** 的版本号字符串，版本号递增规则如下：

1. 主版本号：从 1 开始递增的正整数，当有不兼容的 API 修改时+1
2. 次版本号：从 0 开始递增的正整数，当新增了向下兼容的新功能时+1，当主版本号增加时归 0
3. 修订号：从 0 开始递增的正整数，当做了向下兼容的问题修正时+1，当次版本号增加时归 0

此版本号可用于兼容性判断。
