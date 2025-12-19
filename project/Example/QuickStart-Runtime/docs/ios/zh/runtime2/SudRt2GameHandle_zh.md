# SudRt2GameHandle API 说明

`SudRt2GameHandle` 是在 Cocos Runtime 中实现的、定义了应用层如何和游戏进行交互的功能接口类。此接口的实例由 Cocos Runtime 实例创建并返回给应用层；应用层负责保存、使用和销毁此接口的实例。

本文档中的函数、接口、常量等定义如果没有特别标明所在的类，则属于 `SudRt2GameHandle`，应用层只应在 UI 线程调用此文档中的函数。

## Game Handle 实例的生命周期

Game Handle 实例由 Cocos Runtime API `createGameHandleWithOptions:completion:` 创建。当实例存在时，调用相应的状态操作函数可以切换游戏实例的状态，切换的结果通过 `SudRt2GameStateChangeListener` 反馈给应用层。

生命周期

1. **UNAVAILABLE**: 游戏运行环境未就绪；当 Game Handle 刚创建时为此状态。应在此状态设置游戏启动参数
2. **WAITING**: 游戏运行环境已就绪，但未运行；当游戏界面不可见时应设置为此状态
3. **RUNNING**: 游戏正在运行中，但用户不可交互；当游戏可见但游戏窗口无焦点时应设置为此状态
4. **PLAYING**: 游戏正在运行中，用户可交互；正常执行游戏

## Game Handle 生命周期 APIs

### create

```objc
- (void)create
```

创建游戏运行环境。

操作成功后游戏实例进入 `WAITING` 状态。

只有当游戏启动参数设置正确且目前没有运行环境时才能正确创建游戏运行环境。

### start:

```objc
- (void)start:(NSString *)onShowMsg
```

启动游戏运行环境。

操作成功后游戏实例进入 `RUNNING` 状态。此时游戏脚本正常执行。

当开始游戏或从后台切换到前台时应执行此接口。

**注意**:

1. 调用此方法之后，再使用 `getGameView` 方法获取 `GameView`，并且为 `GameView` 设置大小时，`Runtime` 会通知游戏窗口大小已变化。如果游戏未使用相关接口监听窗口大小变化，并在窗口大小变化时调整画布，可能会导致游戏画面不显示或者显示异常。

**_参数_**

- NSString \*onShowMsg: 程序切前台后，作为 js api `onShow` 回调的参数

### play

```objc
- (void)play
```

游戏环境开始处理玩家输入事件。

操作成功后游戏实例进入 `PLAYING` 状态。在此状态 Runtime 会把用户的输入传递给正在运行的游戏进行处理。

只有当游戏窗口可见且获得输入焦点时才应调用此接口。

### pause

```objc
- (void)pause
```

游戏环境停止处理玩家输入事件。

操作成功后游戏实例进入 `RUNNING` 状态。

当正常玩游戏时，游戏窗口失去焦点但还是屏幕可见，应调用此接口。

### stop:

```objc
- (void)stop:(NSString *)onHideMsg
```

游戏环境停止执行游戏脚本。

操作成功后游戏实例进入 `WAITING` 状态。

当开始游戏或从前台切换到后台时应执行此接口。

**_参数_**

- NSString \*onHideMsg: 程序切后台后，作为 js api `onHide` 回调的参数

### destroy

```objc
- (void)destroy
```

销毁游戏运行环境。

操作成功后游戏实例进入 `UNAVAILABLE` 状态。游戏相关资源被释放。

当游戏不需要再运行时调用此接口。

## Game Handle 事件监听 APIs

### setCustomCommandListener:

```objc
- (void)setCustomCommandListener:(nullable id<SudRt2CustomCommandListener>)listener
```

设置自定义命令监听者。当游戏调用 JS API `callCustomCommand` 时，通过 listener 回调到 APP 模块进行处理。

**_参数_**

- id\<CRCustomCommandListener\> listener: 自定义命令监听者，需要将结果通过 `CRCustomCommandHandle` 的 `success` 等 API 传给调用者。

**_CRCustomCommandListener_**

| 接口                                                                                                             | 接口参数                                                                                   | 说明                             | 版本   |
| :--------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------- | :------------------------------- | :----- |
| - (void)onCallCustomCommand:(id\<GameCustomCommandHandle\>)handle<br/>&emsp;&emsp;info:(NSDictionary \*)argv     | **handle**:通过此 handle<br/>把命令执行结果返回给游戏<br/>**argv**: JS 传入的参数列表<br/> | -                                | -      |
| - (void)onCallCustomCommandSync:(id\<GameCustomCommandHandle\>)handle<br/>&emsp;&emsp;info:(NSDictionary \*)argv | **handle**:通过此 handle<br/>把命令执行结果返回给游戏<br/>**argv**: JS 传入的参数列表<br/> | 同步方法处理，注意当前为游戏线程 | 2.2.10 |

**_CustomCommandHandle_**

| 接口                                                           | 接口参数             | 说明                                                   |
| :------------------------------------------------------------- | :------------------- | :----------------------------------------------------- |
| - (void)customCommandSuccess                                   | -                    | 成功时调用，并将结果返回                               |
| - (void)customCommandFailure:(NSString \*)err                  | err:错误描述         | 失败时调用,如果 err 参数不为 nil 此错误信息会返回给 JS |
| - (void)pushResultWithString:(NSString \*)res                  | res:字符串           | 添加一个返回给 JS 的结果                               |
| - (void)pushResultNull                                         | -                    | 添加一个返回给 JS 的 null                              |
| - (void)pushResultWithBool:(BOOL)res                           | res:布尔值           | 添加一个返回给 JS 的结果                               |
| - (void)pushResultWithLong:(long)res                           | res:整数             | 添加一个返回给 JS 的结果                               |
| - (void)pushResultWithDouble:(double)res                       | res:双精度浮点数     | 添加一个返回给 JS 的结果                               |
| - (void)pushResultWithInt8Arr:(NSData \*)res                   | res:单字节数组       | 添加一个返回给 JS 的结果                               |
| - (void)pushResultWithInt16Arr:(NSData \*)res                  | res:双字节数组       | 添加一个返回给 JS 的结果                               |
| - (void)pushResultWithInt32Arr:(NSData \*)res                  | res:四字节数组       | 添加一个返回给 JS 的结果                               |
| - (void)pushResultWithFloatArr:(NSData \*)res                  | res:单精度浮点数数组 | 添加一个返回给 JS 的结果                               |
| - (void)pushResultWithDoubleArr:(NSData \*)res                 | res:双精度浮点数数组 | 添加一个返回给 JS 的结果                               |
| - (void)pushResultWithBoolArr:(NSArray\<NSNumber \*\> \*)res   | res:布尔数组         | 添加一个返回给 JS 的结果                               |
| - (void)pushResultWithStringArr:(NSArray\<NSString \*\> \*)res | res:字符串数组       | 添加一个返回给 JS 的结果                               |

`CRGameCustomCommandListener` 处理 JS 调用过来的命令时，需要返回给 JS 的结果通过 `CRGameCustomCommandHandle` 的 `pushResult` 系列 API 按调用顺序先缓存在 handle 中， 在 handle 的 `success` API 调用时把结果以参数的形式返回给 JS API `callCustomCommand` 的第一个回调对象的 `success` 回调函数。

通过 `pushResult` 系列 API 返回的结果在 JS 中的表现形式为:

| Objective-C 类型       | JS 类型      | 说明                                 |
| :--------------------- | :----------- | :----------------------------------- |
| nil                    | null         |
| BOOL                   | boolean      |
| long                   | number       |
| double                 | number       |
| NSString               | string       |
| NSData                 | Int8Array    |
| NSData                 | Int16Array   |
| NSData                 | Int32Array   |
| NSData                 | Float32Array |
| NSData                 | Float64Array |
| NSArray\<NSNumber \*\> | [boolean]    | JS 中所有元素都是 boolean 类型的数组 |
| NSArray\<NSString \*\> | [string]     | JS 中所有元素都是 string 类型的数组  |

**_argv 可用字段_**

JS API `callCustomCommand` 调用时除第一个回调对象之外的其它参数都保存在此字段中，读取方法为: 1. 以 "argc" 为 key 获取参数总数 2. 以 "type`N`" 为 key 获取第 `N` 个参数的类型 3. 以 "`N`" 为 key 获取这个参数的值

| 属性      | 数据类型        | 是否必填 | 说明                                 |
| :-------- | :-------------- | :------- | :----------------------------------- |
| "argc"    | int             | 是       | 参数总数量                           |
| "type`N`" | String          | 是       | 参数类型                             |
| "`N`"     | &lt;type`N`&gt; | 是       | 参数值; 数据类型为 "null" 时没有此项 |

`N` 的取值范围为大于第于 0，小于参数总数量的整数。JS API 传入的数据类型到 Objective-C 的对应类型为：

| JS 类型      | Objective-C 类型       | 说明                                |
| :----------- | :--------------------- | :---------------------------------- |
| null         | nil                    |
| boolean      | BOOL                   |
| number       | long                   | JS 数字是整数                       |
| number       | double                 | JS 数字不是整数                     |
| string       | NSString               |
| Int8Array    | NSData                 |
| Int16Array   | NSData                 |
| Int32Array   | NSData                 |
| Float32Array | NSData                 |
| Float64Array | NSData                 |
| [boolean]    | NSArray\<NSNumber \*\> | JS 中的数组所有元素类型都是 boolean |
| [number]     | NSArray\<NSNumber \*>  | JS 中的数组所有元素类型都是 number  |
| [string]     | NSArray\<NSString \*\> | JS 中的数组所有元素类型都是 string  |

### setGameDrawFrameListener:

```objc
- (void)setGameDrawFrameListener:(nullable id<SudRt2GameDrawFrameListener>)listener
```

设置游戏图像绘制事件监听器。

当有设置此监听器时，Runtime 每绘制完成一帧图像会回调一次监听器。为了不影响绘制效率，回调绘制监听器和绘制逻辑是不同线程执行的，应用层不应把此函数回调的时间当成图像绘制完成的时间。

若不再需要每帧回调，则应该再调用该接口并设置参数为 `nil`, 以避免不必要的性能开销。

**_参数_**

- id\<CRGameDrawFrameListener\> listener: 每帧回调监听者

**_CRGameDrawFrameListener_**

| 接口                                   | 接口参数                           | 说明           |
| :------------------------------------- | :--------------------------------- | :------------- |
| - (void)onDrawFrame:(long)frameCounter | **frameCounter**: 已绘制完成的帧数 | 绘制完成后回调 |

### setGameFatalErrorListener:

```objc
- (void)setGameFatalErrorListener:(nullable id<SudRt2GameFatalErrorListener>)listener
```

设置游戏致命错误监听器

**_参数_**

- id\<CRGameFatalErrorListener\> listener: 游戏致命错误监听器

**_CRGameFatalErrorListener_**

| 接口                                          | 接口参数              | 说明                   |
| :-------------------------------------------- | :-------------------- | :--------------------- |
| - (void)onGameFatalError:(NSString \*)message | **message**: 错误消息 | 游戏发生致命错误时调用 |

### setGameLoadSubpackageListener:

```objc
- (void)setGameLoadSubpackageListener:(nullable id<SudRt2GameLoadSubpackageListener>)listener
```

设置加载游戏分包监听者，当游戏加载分包时回调。

**_参数_**

- id\<CRGameLoadSubpackageListener\> listener: 游戏加载分包监听者，需要将结果通过 `GameLoadSubpackageHandle` 的 `success` 等 API 传给调用者。

**_GameLoadSubpackageListener_**

| 接口                                                                                                                                          | 接口参数                                                                                                                  | 说明                     |
| :-------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------ | :----------------------- |
| - (void)onLoadSubpackage:(id\<GameLoadSubpackageHandle\>)handle<br/>&emsp;&emsp;name:(NSString \*)name<br/>&emsp;&emsp;root:(NSString \*)root | **handle**:通过此 handle<br/>把下载并安装分包的结果返回给游戏<br/>**name**: 分包名称<br/>**root**: 根据该值计算分包的 URL | 当游戏请求加载分包时回调 |

**_GameLoadSubpackageHandle_**

| 接口                                                                                                       | 接口参数                                                                                    | 说明                                          |
| :--------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------ | :-------------------------------------------- |
| - (void)loadSubpackageSuccess:(NSString \*)packageName<br/>root:(NSString \*)packageRoot                   | **packageName**: 分包名称<br/>**packageRoot**: 分包相对于游戏包的相对路径<br/>              | APP 模块安装分包成功时调用此接口通知 JS       |
| - (void)loadSubpackageFailure:(NSString \*)packageName <br/>withError:(NSString \*)error                   | **packageName**: 分包名称<br/>**error**: 错误信息                                           | APP 模块安装或下载分包失败时调用此接口通知 JS |
| - (void)loadSubpackageProgress:(NSString \*)packageName<br/>downloaded:(long)written<br/>total:(long)total | **packageName**: 分包名称<br/>**written**: 已经下载完成的大小 id <br/>**total**: 分包总大小 | APP 模块更新加载分包进度时调用此接口通知 JS   |

### setGameQueryClipboardListener:

```objc
- (void)setGameQueryClipboardListener:(nullable id<GameQueryClipboardListener>)listener
```

设置游戏剪切板操作请求监听器。

在未设置任何剪切板操作请求监听器的情况下，默认允许任何游戏从剪切板读取数据或者写入数据到剪切板。

**_GameQueryClipboardListener_**

| 接口                                                                                                                                              | 接口参数                                                                                                     | 说明                                                                     |
| :------------------------------------------------------------------------------------------------------------------------------------------------ | :----------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------- |
| - (void)onSetClipboardData:(id\<GameQueryClipboardHandle\>)handle<br/>&emsp;&emsp;data:(NSString \*)data<br/>&emsp;&emsp;appId:(NSString \*)appId | **handle**: 用于处理设置剪切板数据及结果回调 <br/>**data**: 设置到剪切板的数据<br/>**appId**: 游戏唯一性标识 | 游戏申请设置剪切板数据时调用，如未实现此接口，则默认允许设置数据到剪切板 |
| - (void)onGetClipboardData:(id\<GameQueryClipboardHandle\>)handle<br/>&emsp;&emsp;data:(NSString \*)data<br/>&emsp;&emsp;appId:(NSString \*)appId | **handle**: 用于处理获取剪切板数据及结果回调 <br/>**data**: 从剪切板获取的数据<br/>**appId**: 游戏唯一性标识 | 游戏申请获取剪切板数据时调用，如未实现此接口，则默认允许从剪切板获取数据 |

**_GameQueryClipboardHandle_**

| 接口                                            | 接口参数             | 说明                   |
| :---------------------------------------------- | :------------------- | :--------------------- |
| - (void)rejectGetClipboardData                  | -                    | 拒绝从剪切板中获取数据 |
| - (void)allowGetClipboardData:(NSString \*)data | **data**: 获取的数据 | 允许从剪切板中获取数据 |
| - (void)rejectSetClipboardData                  | -                    | 拒绝设置数据到剪切板   |
| - (void)allowSetClipboardData:(NSString \*)data | **data**: 设置的数据 | 允许将数据设置到剪切板 |

### setGameQueryExitListener:

```objc
- (void)setGameQueryExitListener:(nullable id<GameQueryExitListener>)listener
```

设置游戏退出请求监听器。

若确认退出，需在回调中调用 destroy 退出游戏。

若不设置回调则游戏申请退出时直接退出。

**_参数_**

- id\<GameQueryExitListener\> listener: 游戏退出请求监听者

**_GameQueryExitListener_**

| 接口                                                                              | 接口参数                                                     | 说明               |
| :-------------------------------------------------------------------------------- | :----------------------------------------------------------- | :----------------- |
| - (void)onQueryExit:(NSString \*)appID<br/>&emsp;&emsp;result:(NSString \*)result | **appID**: 游戏唯一性标识 id <br/>**result**: 请求退出的文本 | 游戏请求退出时调用 |

### setGameQueryPermissionListener:

```objc
- (void)setGameQueryPermissionListener:(nullable id<SudRt2GameQueryPermissionListener>)listener
```

设置游戏权限请求监听器。

**_应用必须设置并实现此监听器，否则游戏授权功能无法正常使用。_**

**_参数_**

- id\<CRGameQueryPermissionListener\> listener: 游戏权限请求监听者，处理授权申请，需要将结果通过 `CRGameQueryPermissionHandle` 的 `completeQueryPermission:authStatus:` API 传给调用者。

**_CRGameQueryPermissionListener_**

| 接口                                                                                                                                                                                                                        | 接口参数                                                                                                                             | 说明                                          |
| :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------- |
| - (void)onQueryPermission:(id\<GameQueryPermissionHandle\>)handle<br/>&emsp;&emsp;permission:(NSString \*)permission<br/>&emsp;&emsp;appId:(NSString \*)appId<br/>&emsp;&emsp;authStatus:(CRPermissionAuthStatus)authStatus | **handle**: 权限申请结果回调 <br/>**permission**: 游戏申请的权限 <br/>**appId**: 游戏唯一性标识 id <br/>**authStatus**: 权限授权状态 | 游戏向`Runtime`申请系统权限和自定义权限时回调 |

当游戏调用`authorize`时，会向`Runtime`请求权限，然后回调该方法。用户需要在此方法实现自定义的权限申请和提示界面，引导用户进行授权。此时，只是`Runtime`得到了用户的授权，但`Runtime`并不会立刻向系统申请指定权限。

**_CRPermissionAuthStatus_**

```objc
typedef enum : NSUInteger {
    CR_PERMISSION_AUTH_STATUS_UNDETERMINED = 0, // 未申请
    CR_PERMISSION_AUTH_STATUS_GRANTED = 1, // 已授权
    CR_PERMISSION_AUTH_STATUS_DENIED = 2, // 已拒绝
} CRPermissionAuthStatus
```

**_CRGameQueryPermissionHandle 接口_**

| 接口                                                                                                                  | 接口参数                                                | 说明         |
| :-------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------ | :----------- |
| - (void)completeQueryPermission:(NSString \*)permission<br/>&emsp;&emsp;authStatus:(CRPermissionAuthStatus)authStatus | **permission**: 申请的权限<br/>**authStatus**: 授权状态 | 授权结果回调 |

**_permission 支持的参数_**

| 属性                   | 数据类型 | 对应接口                  | 说明       |
| :--------------------- | :------- | :------------------------ | :--------- |
| scope.userInfo         | NSString | rt.getUserInfo            | 用户信息   |
| scope.userLocation     | NSString | rt.getLocation            | 地理位置   |
| scope.writePhotosAlbum | NSString | rt.saveImageToPhotosAlbum | 保存到相册 |
| scope.record           | NSString | RecordManager.start       | 录音       |
| scope.camera           | NSString | rt.createCamera           | 拍照或录像 |
| 自定义权限             | NSString | 自定义接口                | 自定义功能 |

### setGameQuerySystemPermissionListener:

```objc
- (void)setGameQuerySystemPermissionListener:(nullable id<SudRt2GameQuerySystemPermissionListener>)listener
```

设置`Runtime`模块请求系统权限的监听器。

如果应用需要在系统服务被关闭或者权限被用户拒绝的情况再次提示或者引导用户，请设置此监听者。

**_参数_**

- id\<CRGameQuerySystemPermissionListener\> listener: 系统权限请求监听者，处理系统授权申请，需要通过 `CRGameQuerySystemPermissionHandle` 的 `continueQuerySystemPermission:` API 告诉调用者已经处理结束。

**_CRSystemPermissionAuthStatus_**

```objc
typedef enum : NSUInteger {
    CR_SYSTEM_PERMISSION_AUTH_STATUS_UNDETERMINED = 0, // 未申请
    CR_SYSTEM_PERMISSION_AUTH_STATUS_GRANTED = 1, // 已授权
    CR_SYSTEM_PERMISSION_AUTH_STATUS_DENIED = 2, // 已拒绝
} CRSystemPermissionAuthStatus
```

**_CRGameQuerySystemPermissionListener_**

| 接口                                                                                                                                                                                                                                                                                                                                                 | 接口参数                                                                                                                                                                                                      | 说明                          |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :---------------------------- |
| - (void)beforeQuerySystemPermission:(id\<CRGameQuerySystemPermissionHandle\>)handle<br/>&emsp;&emsp;fromJSMethod:(NSString \*)methodName<br/>&emsp;&emsp;permission:(NSString \*)permission<br/>&emsp;&emsp;appId:(NSString \*)appId<br/>&emsp;&emsp;authStatus:(CRSystemPermissionAuthStatus)authStatus<br/>&emsp;&emsp;serviceStatus:(BOOL)enabled | **handle**: 申请结果回调<br/>**fromJSMethod**: 产生本次授权的 JS 方法名<br/>**permission**: 申请的权限 <br/>**appId**: 游戏唯一性标识 id<br/>**authStatus**: 系统权限状态<br/>**serviceStatus**: 系统服务状态 | `Runtime`向系统申请权限前调用 |

`Runtime`使用权限延迟申请策略，当调用需要系统权限的接口时才会向系统申请对应的权限。当`Runtime`将要向系统申请权限之前，会回调此方法。

**_CRGameQuerySystemPermissionHandle_**

| 接口                                                          | 接口参数                   | 说明               |
| :------------------------------------------------------------ | :------------------------- | :----------------- |
| - (void)continueQuerySystemPermission:(NSString \*)permission | **permission**: 申请的权限 | 授权处理完毕后回调 |

**_permission 支持的参数_**

请参照`CRGameQueryPermissionHandle接口`的 permission 参数。

### setGameScreenStateChangeListener:

```objc
- (void)setGameScreenStateChangeListener:(nullable id<SudRt2GameScreenStateChangeListener>)listener
```

设置游戏屏幕状态变化监听器。

游戏想要改变屏幕状态时调用。

在未设置任何屏幕状态变化监听器的情况下，默认允许任何游戏设置屏幕亮度和屏幕常亮状态。

**_参数_**

- id\<CRGameScreenStateChangeListener\> listener: 游戏屏幕状态变化监听者，处理屏幕状态变化申请。

**_CRGameScreenStateChangeListener_**

| 接口                                                                                              | 接口参数                                         | 说明                                                                                                                                                                  |
| :------------------------------------------------------------------------------------------------ | :----------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| - (BOOL)queryChangeScreenBrightness:(float)brightness <br/>&emsp;&emsp;info:(NSDictionary \*)info | **brightness**: 屏幕亮度 <br/>**info**: 游戏信息 | 游戏想要改变屏幕亮度时调用<br/>返回 NO，则 Runtime 忽略该游戏屏幕亮度设置<br/>返回 YES，则 Runtime 将把屏幕亮度设置为 brightness<br/>未实现此接口时，默认返回 YES     |
| - (BOOL)queryChangeScreenKeepOn:(BOOL)keepOn <br/>&emsp;&emsp;info:(NSDictionary \*)info          | **keepOn**: 屏幕是否常亮 <br/>**info**: 游戏信息 | 游戏想要设置屏幕常亮状态时调用<br/>返回 NO，则 Runtime 忽略该游戏屏幕常亮设置<br/>返回 YES，则 Runtime 将把屏幕常亮状态设置为 keepOn<br/>未实现此接口时，默认返回 YES |

**_info 可用字段_**

方法调用时，会带上游戏相关的信息:

| 属性                        | 数据类型 | 说明           |
| :-------------------------- | :------- | :------------- |
| SUD_RT2_KEY_PACKAGE_GAME_ID | NSString | 游戏的唯一标识 |

### setGameStateListener:

```objc
- (void)setGameStateListener:(nullable id<SudRt2GameStateChangeListener>)listener
```

设置游戏状态变更监听器。

调用游戏操作接口时，游戏状态可能会经历多个阶段，每个阶段的状态变化都会回调。

若调用游戏操作接口时的当前游戏状态与目标游戏状态一样，则 `SudRt2GameStateChangeListener`不会被回调。

**_参数_**

- id\<SudRt2GameStateChangeListener\> listener: 状态变更监听器

**_SudRt2GameStateChangeListener_**

| 接口                                                                                                                      | 接口参数                                                                    | 说明                 |
| :------------------------------------------------------------------------------------------------------------------------ | :-------------------------------------------------------------------------- | :------------------- |
| - (void)preStateChangedFrom:(int)fromState<br/>&emsp;&emsp;to:(int)toState                                                | **fromState**: 当前状态<br/>**toState**: 下一个状态                         | 状态将要切换时的回调 |
| - (void)onStateChangedFrom:(int)fromState<br/>&emsp;&emsp;to:(int)toSstate                                                | **fromState**: 上一个状态<br/>**toState**: 当前状态                         | 状态切换成功后回调   |
| - (void)onStateChangedFailureFrom:(int)fromState<br/>&emsp;&emsp;to:(int)toSstate<br/>&emsp;&emsp;error:(NSError \*)error | **fromState**: 当前状态<br/>**toState**: 下一个状态<br/>**error**: 错误信息 | 状态切换失败后回调   |

### setMediaPlayerListener

```objc
    - (void)setMediaPlayerListener:(nullable id<SudRt2MediaPlayerListener>)listener
```

设置 Runtime MediaPlayer 实例监听器，如果不需要监听 Runtime MediaPlayer 实例相关事件，则无需调用此接口, 此接口需要在 js 层调用 creatVideo 之前使用, 最低 core 版本 2.4.0。

此监听器的回调在主线程被执行。

**_参数_**

- id\<CRMediaPlayerListener\> listener: 实现 CRMediaPlayerListener 接口的实例

**_CRMediaPlayerListener_**

| 接口                                               | 接口参数                | 说明                                                                                                                                                                                     |
| -------------------------------------------------- | ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| - (void)onMediaPlayerCreated:(UInt64) instanceID   | **instanceID**：实例 id | 当 Runtime 底层创建好 Runtime MediaPlayer 实例，会调用该接口函数将该实例的 instanceID 返回给应用层。应用层可以在此回调中创建一个与 Runtime MediaPlayer 实例交互的 MediaPlayerHandle 实例 |
| - (void)onMediaPlayerDestroyed:(UInt64) instanceID | **instanceID**：实例 id | 底层销毁 Runtime MediaPlayer 实例时，会调用该接口函数将该实例的 instanceID 返回给应用层。应用层可以在此回调中做和 instanceID 相关的内存回收                                              |

### getMediaPlayerHandle

```objc
    - (id<SudRt2CocosGameMediaPlayerHandle>)getMediaPlayerHandle:(UInt64) instanceID
```

获取一个与 Runtime MediaPlayer 实例交互的 MediaPlayerHandle 实例, 最低 core 版本 2.4.0。

该接口只应在 onMediaPlayerCreated 回调中或之后使用 instanceID 为参数被调用，如无相关需求，亦可不调用。

**_参数_**

- UInt64 instanceID: Runtime MediaPlayer 实例 id

**_返回值_**

返回一个与 Runtime MediaPlayer 实例交互的 MediaPlayerHandle 实例，详见 Cocos Runtime CRCocosGameMediaPlayerHandle API 说明文档。

## Game Handle 其他 APIs

### getGameAudioSession

```objc
- (id<SudRt2CocosGameAudioSession>)getGameAudioSession
```

返回由 Cocos Runtime 创建的游戏音频会话对象，应用层可以用它对当前游戏的所有音频进行控制，详情参看《Cocos Runtime Game Audio 音频操作说明》文档。

### getGameState

```objc
- (NSInteger)getGameState
```

返回当前游戏运行状态

### getGameView

```objc
- (UIView *)getGameView
```

返回由 Cocos Runtime 创建的由游戏进行绘制的显示界面 UIView，应用层可以在里面添加其它界面元素以达到界面定制的目的。

### runScript:completion:

```objc
- (void)runScript:(NSString *)script
       completion:(nullable void (^)(NSString * _Nullable returnType,
                                     NSDictionary * _Nullable returnValue,
                                     NSError * _Nullable error))completion
```

执行一段字符串脚本，结果通过 `completion` 返回。

**_参数_**

- NSString \*script: 可执行的 JS 脚本字符串
- void (^completion)(NSString _ \_Nullable returnType, NSDictionary _ \_Nullable returnValue, NSError \* \_Nullable error): 运行脚本结果回调

**_回调参数说明_**

| 回调                                                                                                                     | 回调参数                                                                                                  | 说明 |
| :----------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------- | :--- |
| void (^completion)(NSString _ \_Nullable returnType, NSDictionary _ \_Nullable returnValue, NSError \* \_Nullable error) | **returnType**:执行脚本成功的返回值类型<br/>**returnValue**: 执行脚本成功的返回值<br/>**error**: 错误描述 | -    |

**_returnValue 可用字段_**

运行 自定义脚本 成功后，返回的数据都保存在此字段中，读取方法为:

以 "value" 为 key 获取这个参数的值

| 属性    | 数据类型     | 是否必填 | 说明                                 |
| :------ | :----------- | :------- | :----------------------------------- |
| "value" | &lt;type&gt; | 是       | 参数值; 数据类型为 "null" 时没有此项 |

脚本的返回值的数据类型到 Objective-C 的对应类型为：

| JS 类型 | Objective-C 类型 |
| :------ | :--------------- |
| null    | nil              |
| boolean | NSNumber         |
| number  | NSNumber         |
| string  | NSString         |

### setGameStartOptions:options:

```objc
- (BOOL)setGameStartOptions:(NSString *)id
                    options:(NSDictionary *)options
```

设置游戏启动时所需的参数信息。

要正常执行游戏，至少需要指定要启动的游戏的唯一标识 `id`，其它可选参数可通过可选参数 `options` 传入 `GameHandle` 实例。

在调用该接口前，`id` 对应的游戏包应已正确安装。

**_参数_**

- NSString \*id: 游戏唯一性标识 id
- NSDictionary \*options: 可选参数，游戏启动参数信息, 详见 **支持的游戏运行参数**

**_支持的游戏运行参数_**

| 属性                                                            | 数据类型 | 是否必填 | 默认值                           | 说明                                                                                                                                                                                                                                                                                                           | 支持版本                 |
| :-------------------------------------------------------------- | :------- | :------- | :------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------------------- |
| SUD_RT2_KEY_GAME_DEBUG_OPTION_ENABLE_DEBUGGER                   | BOOL     | 否       | false                            | 是否开启 Safari JS 调试。在 iOS16.4 以下系统中，该配置无效，debug 版默认开启                                                                                                                                                                                                                                   | runtime 版本 &gt;= 2.4.0 |
| SUD_RT2_KEY_GAME_DEBUG_OPTION_ENABLE_FPS                        | BOOL     | 否       | false                            | 是否开启 FPS 显示                                                                                                                                                                                                                                                                                              |                          |
| SUD_RT2_KEY_GAME_DEBUG_OPTION_ENABLE_V_CONSOLE                  | BOOL     | 否       | false                            | 是否开启 VConsole                                                                                                                                                                                                                                                                                              |                          |
| SUD_RT2_KEY_GAME_START_OPTIONS_GAME_VERSION                     | NSString | 否       |                                  | 游戏版本号                                                                                                                                                                                                                                                                                                     |
| SUD_RT2_KEY_GAME_START_OPTIONS_CUSTOM_SEARCH_PATH               | NSString | 否       |                                  | 指定一个目录为脚本搜索路径                                                                                                                                                                                                                                                                                     |
| SUD_RT2_KEY_GAME_START_OPTIONS_CUSTOM_JS_ENTRY                  | NSString | 否       |                                  | 指定自定义脚本路径                                                                                                                                                                                                                                                                                             |
| SUD_RT2_KEY_GAME_START_OPTIONS_DISABLE_DEFAULT_JS_ENTRY         | BOOL     | 否       | false                            | 禁用默认游戏入口脚本 main.js                                                                                                                                                                                                                                                                                   |
| SUD_RT2_KEY_GAME_START_OPTIONS_LIMIT_DOWNLOAD_CONTENT_SIZE      | int      | 否       | 50                               | 设置单次下载允许的大小上限<br/>&gt;=0,单位 MiB                                                                                                                                                                                                                                                                 |                          |
| SUD_RT2_KEY_GAME_START_OPTIONS_LIMIT_USER_STORAGE               | int      | 否       | 50                               | 设置用户存储空间限额<br/>&gt;=0,单位 MiB<br/>设置值为 -1 时，关闭用户存储空间的大小限制<br/>减小设置值时不会删除已多占的空间<br/>                                                                                                                                                                              |                          |
| SUD_RT2_KEY_GAME_START_OPTIONS_LIMIT_LOCAL_STORAGE              | int      | 否       | 10                               | 设置本地存储空间最大字符个数<br/>&gt;=0,单位 MiB<br/>减小设置值时不会删除已多占的空间<br/>                                                                                                                                                                                                                     |
| SUD_RT2_KEY_GAME_START_OPTIONS_LAUNCH_OPTIONS                   | String   | 否       |                                  | 需要传递给游戏的启动参数                                                                                                                                                                                                                                                                                       |
| SUD_RT2_KEY_GAME_START_OPTIONS_NETWORK_TIMEOUT_DOWNLOAD         | int      | 否       | 60000                            | downloadFile 的超时时间，单位：毫秒                                                                                                                                                                                                                                                                            | runtime 版本 &gt;= 2.0.0 |
| SUD_RT2_KEY_GAME_START_OPTIONS_NETWORK_TIMEOUT_UPLOAD           | int      | 否       | 60000                            | uploadFile 的超时时间，单位：毫秒。                                                                                                                                                                                                                                                                            | runtime 版本 &gt;= 2.0.0 |
| SUD_RT2_KEY_GAME_START_OPTIONS_NETWORK_TIMEOUT_WEB_SOCKET       | int      | 否       | 60000                            | websocket 连接的超时时间，单位：毫秒                                                                                                                                                                                                                                                                           | runtime 版本 &gt;= 2.0.0 |
| SUD_RT2_KEY_GAME_START_OPTIONS_NETWORK_TIMEOUT_XML_HTTP_REQUEST | int      | 否       | 60000                            | XMLHttpRequest 的超时时间，单位：毫秒                                                                                                                                                                                                                                                                          | runtime 版本 &gt;= 2.0.0 |
| SUD_RT2_KEY_GAME_START_OPTIONS_ENABLE_THIRD_SCRIPT              | BOOL     | 否       | false                            | 是否允许执行动态脚本(eval)                                                                                                                                                                                                                                                                                     |                          |
| SUD_RT2_KEY_GAME_START_OPTIONS_ENABLE_TIMING_LOG                | BOOL     | 否       | true                             | 是否开启游戏启动耗时 log 输出                                                                                                                                                                                                                                                                                  |                          |
| SUD_RT2_KEY_GAME_START_OPTIONS_WEBGL_RENDER_THREAD_MODE         | int      | 否       | CR_WEBGL_RENDER_THREAD_MODE_AUTO | 设置游戏中 WebGL 上下文的渲染线程<br/>CR_WEBGL_RENDER_THREAD_MODE_AUTO: 由 Runtime 决定渲染线程<br/>CR_WEBGL_RENDER_THREAD_MODE_STANDALONE: 在一个独立的线程渲染游戏画面<br/>CR_WEBGL_RENDER_THREAD_MODE_GAME_THREAD: 在游戏线程渲染游戏画面<br/>CR_WEBGL_RENDER_THREAD_MODE_UI_THREAD: 在 UI 线程渲染游戏画面 | core 版本 &gt;= 2.4.0    |
| SUD_RT2_KEY_PACKAGE_CONTENT_PATH                                | NSString | 否       |                                  | 强制指定需要启动的小游戏资源根目录                                                                                                                                                                                                                                                                             |                          |
| SUD_RT2_KEY_USER_GAME_TEMP_PATH                                 | NSString | 否       |                                  | 强制指定用户临时存储目录                                                                                                                                                                                                                                                                                       |                          |
| SUD_RT2_KEY_USER_GAME_DATA_PATH                                 | NSString | 否       |                                  | 强制指定用户数据存储目录                                                                                                                                                                                                                                                                                       |                          |

在 Runtime 加载游戏入口脚本 `main.js` 前，会先加载 `SUD_RT2_KEY_GAME_START_OPTIONS_CUSTOM_JS_ENTRY` 参数指定的自定义脚本，自定义脚本只支持一个脚本文件，支持以下形式的路径:

1. '/'开头的绝对路径，当自定义脚本存储在文件系统中时，可以使用此种形式的路径
2. 相对路径，此路径是指小游戏包内的路径

**_返回值_**

若参数设置无误返回 YES，如果有非法参数则返回 NO。
