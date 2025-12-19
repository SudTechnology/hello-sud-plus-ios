# SudRt2GameRuntime API Documentation

`SudRt2GameRuntime` is an interface class implemented within the Runtime.
It defines the application-layer functionalities for managing game-related content.
There should only be **one instance** of this interface in a single process, created through `SudRt2GameRuntime`.

---

## Steps to Create a Mini-Game Runtime Environment

1. Call `SudRt2GameRuntime`’s `createGameHandleWithOptions:completion:` to create the game runtime environment.

---

## Runtime Game API

Unless otherwise specified, the following functions, interfaces, and constants belong to the `SudRt2GameRuntime` class.

---

### createRuntimeWithOptions:completion:

```objc
+ (void)createRuntimeWithOptions:(NSDictionary *)options
                      completion:(nullable void (^)(id<SudRt2GameRuntime> _Nullable runtime,
                                                    NSError * _Nullable error))completion
```

Creates an instance that implements the `SudRt2GameRuntime` interface.

The application layer should retain the `SudRt2GameRuntime` instance and set it to `nil` when it’s no longer needed.
Only one instance of `SudRt2GameRuntime` should be active at any given time.

#### Parameters

- `NSDictionary *options`: Runtime initialization parameters (see table below)
- `void (^completion)(id<SudRt2GameRuntime> _Nullable runtime, NSError * _Nullable error)`: Completion callback

#### Runtime Initialization Parameters

| Key                                       | Type     | Required | Default Value                                                              | Description                                     | Version |
| :---------------------------------------- | :------- | :------- | :------------------------------------------------------------------------- | :---------------------------------------------- | :------ |
| `SUD_RT2_KEY_RUNTIME_ASSETS_PATH`         | NSString | No       | `[NSBundle bundleForClass:[CRGameSystem class]] + "default-assets.bundle"` | Path to the core asset resources                |         |
| `SUD_RT2_KEY_RUNTIME_STORAGE_PATH_APP`    | NSString | No       | `NSCachesDirectory + "/app"`                                               | Mini-game installation directory                |         |
| `SUD_RT2_KEY_RUNTIME_STORAGE_PATH_CACHE`  | NSString | No       | `NSTemporaryDirectory`                                                     | Temporary storage directory used during runtime |         |
| `SUD_RT2_KEY_RUNTIME_STORAGE_PATH_USER`   | NSString | No       | `NSCachesDirectory + "/user"`                                              | Player data directory                           |         |
| `SUD_RT2_KEY_RUNTIME_STORAGE_PATH_PLUGIN` | NSString | No       | `NSCachesDirectory + "/plugin"`                                            | Mini-game plugin directory                      |         |

#### Completion Callback Description

| Callback                                                                                 | Parameters                                                                  | Description                          |
| :--------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------- | :----------------------------------- |
| `void (^completion)(id<SudRt2GameRuntime> _Nullable runtime, NSError * _Nullable error)` | **runtime**: Initialized runtime instance<br>**error**: Error info (if any) | Invoked when initialization succeeds |

---

## Runtime APIs

Unless otherwise stated, the following functions and constants belong to the `SudRt2GameRuntime` class.

---

### cancelCleanUp

```objc
- (void)cancelCleanUp
```

Cancels the cleanup task that removes expired temporary files.

---

### cleanUpExpiredTemporaryFiles

```objc
- (void)cleanUpExpiredTemporaryFiles:(NSInteger)keepTimeInMinute
                               start:(nullable void (^)(void))start
                            progress:(nullable void (^)(NSString *path, NSError * _Nullable error))progress
                          completion:(nullable void (^)(NSError * _Nullable error))completion
```

Cleans up expired temporary files.

#### Parameters

- `NSInteger keepTimeInMinute`: The retention period (in minutes) for temporary files.
  Files whose last access time exceeds this threshold are deleted.
- `void (^start)(void)`: Called when cleanup begins.
- `void (^progress)(NSString *path, NSError * _Nullable error)`: Called during cleanup for each file/folder.
- `void (^completion)(NSError * _Nullable error)`: Called when cleanup is completed.

#### Callback Description

| Callback                                                      | Parameters                                                                           | Description                         |
| :------------------------------------------------------------ | :----------------------------------------------------------------------------------- | :---------------------------------- |
| `void (^start)(void)`                                         | –                                                                                    | Invoked when cleanup starts         |
| `void (^progress)(NSString *path, NSError * _Nullable error)` | **path**: Absolute path of the file/folder<br>**error**: Error info (nil on success) | Called for each file during cleanup |
| `void (^completion)(NSError * _Nullable error)`               | **error**: Error info                                                                | Called after cleanup completes      |

---

### createGameHandleWithOptions:completion:

```objc
- (void)createGameHandleWithOptions:(NSDictionary *)options
                         completion:(nullable void (^)(id<SudRt2GameRuntime> _Nullable handle,
                                                       NSError * _Nullable error))completion
```

Creates a game runtime handle instance.

Currently, only **one game runtime instance per process** is supported.
If you need to reuse the instance, perform operations as shown below:

```objc
[gameHandle destroy];
// ...other operations
[gameHandle setGameStartOptions];
// ...other operations
[gameHandle start];
```

#### Parameters

- `NSDictionary *options`: Parameters for creating the GameHandle.
- `void (^completion)(id<SudRt2GameRuntime> _Nullable handle, NSError * _Nullable error)`: Completion callback.

#### GameHandle Creation Parameters

| Key                                         | Type      | Required | Default                                   | Description                                                                                        | Version |
| :------------------------------------------ | :-------- | :------- | :---------------------------------------- | :------------------------------------------------------------------------------------------------- | :------ |
| `SUD_RT2_KEY_GAME_USER_ID`                  | NSString  | Yes      | –                                         | Unique user identifier. Runtime keeps isolated data for each player.                               |         |
| `SUD_RT2_KEY_GAME_HTTP_CACHE_LIMIT_STORAGE` | NSInteger | No       | `200`                                     | Maximum size of HTTP response cache (MB). Must be a positive integer.                              |         |
| `SUD_RT2_KEY_GAME_HTTP_CACHE_PATH`          | NSString  | No       | `/Library/Caches/(application bundle id)` | Path for HTTP cache. The full path is `/Library/Caches/(application bundle id)/(your cache path)`. |         |

#### Completion Callback Description

| Callback                                                                                | Parameters                                                        | Description                     |
| :-------------------------------------------------------------------------------------- | :---------------------------------------------------------------- | :------------------------------ |
| `void (^completion)(id<SudRt2GameRuntime> _Nullable handle, NSError * _Nullable error)` | **handle**: Game runtime handle instance<br>**error**: Error info | Invoked when creation completes |

---

### getManagerWithName:options:

```objc
- (NSObject *)getManagerWithName:(NSString *)name
                         options:(NSDictionary *)options
```

Retrieves the manager instance corresponding to the given name.
Each manager instance is unique within a runtime instance.

#### Parameters

- `NSString *name`: The name of the manager to retrieve.
- `NSDictionary *options`: Optional parameters (currently only supports `nil`).

#### Valid Manager Names

| Name                       | Interface | Description |
| :------------------------- | :-------- | :---------- |
| _None currently available_ | –         | –           |

#### Return Value

Returns the manager instance (`NSObject` type) if a valid name is provided; otherwise returns `nil`.
You must cast the result to the appropriate interface class before using it.

---

### getRuntimeDesc

```objc
+ (NSString *)getRuntimeDesc
```

Returns the version description of the Runtime SDK module.
This is a **human-readable string** that may include:

1. Development phase: `alpha`, `beta`, `RC`, `release`, etc.
2. Release date
3. Additional descriptive info

> ⚠️ Do **not** use this string for version compatibility checks.

---

### getRuntimeFeatures

```objc
+ (NSArray<NSString *> *)getRuntimeFeatures
```

Returns the list of features supported by the Runtime.
Use this API to check feature compatibility across different Runtime versions.

---

### getRuntimeVersion

```objc
+ (NSString *)getRuntimeVersion
```

Returns the **version number** of the Runtime SDK module,
in the format: **major.minor.patch**

#### Version Increment Rules

1. **Major**: Incremented when incompatible API changes occur.
2. **Minor**: Incremented when new backward-compatible features are added; reset to 0 when the major version changes.
3. **Patch**: Incremented for backward-compatible bug fixes; reset to 0 when the minor version changes.

> This version number can be safely used for compatibility checks.
