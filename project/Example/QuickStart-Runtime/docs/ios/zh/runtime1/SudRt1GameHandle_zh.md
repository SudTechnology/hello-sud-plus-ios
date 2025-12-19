# SudRt1GameHandle 接口文档

## 概述

ISudRt1GameHandle 是游戏实例的核心接口，负责游戏的生命周期管理、状态控制和视图获取等功能。

## 接口方法

### 1. setStateHandler

**功能**：设置游戏状态监听器  
**方法签名**：

```objective-c
- (void)setStateHandler:(id<ISudRt1GameStateListener>)stateListener;
```

**参数说明**：
| 参数名 | 类型 | 说明 |
|--------|------|------|
| stateListener | id<ISudRt1GameStateListener> | 游戏状态监听器对象 |

**使用示例**：

```objective-c
[gameHandle setStateHandler:self];
```

---

### 2. getGameView

**功能**：获取游戏视图  
**方法签名**：

```objective-c
- (UIView *)getGameView;
```

**返回值**：
| 类型 | 说明 |
|------|------|
| UIView \* | 游戏渲染视图，可直接添加到视图层级中 |

**使用示例**：

```objective-c
UIView *gameView = [gameHandle getGameView];
[self.view addSubview:gameView];
```

---

### 3. notifyStateChange

**功能**：向游戏发送用户自定义消息（状态变更通知）  
**方法签名**：

```objective-c
- (void)notifyStateChange:(const NSString *)state
                 dataJson:(NSString *)dataJson
                 listener:(nullable ISudListenerNotifyStateChange)listener;
```

**参数说明**：
| 参数名 | 类型 | 说明 |
|--------|------|------|
| state | const NSString _ | 状态名称，标识要通知的游戏状态 |
| dataJson | NSString _ | 状态数据，JSON 格式的字符串 |
| listener | ISudListenerNotifyStateChange | 回调监听器（可为空） |

**回调类型定义**：

```objective-c
typedef void (^ISudListenerNotifyStateChange)(NSInteger retCode, NSString *retMsg);
```

**使用示例**：

```objective-c
[gameHandle notifyStateChange:@"game_custom_message"
                     dataJson:@"{\"type\":\"move\",\"direction\":\"left\"}"
                     listener:^(NSInteger retCode, NSString *retMsg) {
    if (retCode == 0) {
        NSLog(@"状态通知成功");
    } else {
        NSLog(@"状态通知失败: %@", retMsg);
    }
}];
```

---

### 4. start

**功能**：启动游戏  
**方法签名**：

```objective-c
- (void)start;
```

**说明**：首次启动游戏时调用，初始化游戏资源并开始运行。

**使用示例**：

```objective-c
[gameHandle start];
```

---

### 5. play

**功能**：恢复游戏运行（与 pause 配对使用）  
**方法签名**：

```objective-c
- (void)play;
```

**说明**：在游戏被暂停后调用，恢复游戏逻辑和渲染。

**使用示例**：

```objective-c
[gameHandle play];
```

---

### 6. pause

**功能**：暂停游戏（与 play 配对使用）  
**方法签名**：

```objective-c
- (void)pause;
```

**说明**：临时暂停游戏运行，暂停游戏逻辑和渲染以节省资源。

**使用示例**：

```objective-c
[gameHandle pause];
```

---

### 7. destroy

**功能**：销毁游戏实例  
**方法签名**：

```objective-c
- (void)destroy;
```

**说明**：释放游戏占用的所有资源，游戏实例销毁后不可再使用。

**使用示例**：

```objective-c
[gameHandle destroy];
gameHandle = nil;
```

---

## 游戏状态监听器接口 (ISudRt1GameStateListener)

### onStateChanged

**功能**：游戏状态变更回调  
**方法签名**：

```objective-c
-(void)onStateChanged:(NSString*)state
             dataJson:(NSString*)dataJson
               handle:(id<ISudRt1GameStateHandle>)handle;
```

**参数说明**：
| 参数名 | 类型 | 说明 |
|--------|------|------|
| state | NSString _ | 游戏状态标识 |
| dataJson | NSString _ | 状态数据，JSON 格式字符串 |
| handle | id<ISudRt1GameStateHandle> | 游戏状态处理器，用于响应特定状态 |

**实现示例**：

```objective-c
- (void)onStateChanged:(NSString*)state
             dataJson:(NSString*)dataJson
               handle:(id<ISudRt1GameStateHandle>)handle {

    if ([state isEqualToString:@"game_ready"]) {
        NSLog(@"游戏已准备就绪");
        // 处理游戏就绪逻辑
    } else if ([state isEqualToString:@"game_score"]) {
        // 解析分数信息
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[dataJson dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        NSInteger score = [data[@"score"] integerValue];
        NSLog(@"当前分数: %ld", score);
    }
    // ... 其他状态处理
}
```

---

## 生命周期管理建议

### 标准使用流程

```objective-c
// 1. 创建游戏实例
id<ISudRt1GameHandle> gameHandle = [SudRT1 createGame:config];

// 2. 设置状态监听
[gameHandle setStateHandler:self];

// 3. 获取并添加游戏视图
UIView *gameView = [gameHandle getGameView];
[self.view addSubview:gameView];

// 4. 启动游戏
[gameHandle start];

// 5. 游戏运行中可调用 pause/play 控制暂停恢复

// 6. 游戏结束时销毁
[gameHandle destroy];
```

### 注意事项

1. **线程安全**：所有接口方法都应在主线程调用
2. **生命周期**：确保游戏实例的创建和销毁配对使用，避免内存泄漏
3. **状态监听**：设置状态监听器应在调用 start 方法之前
4. **视图管理**：getGameView 返回的视图需要正确添加到视图层级并设置合适的 frame
5. **资源释放**：游戏销毁后应释放所有相关引用

### 错误处理

- 所有异步操作通过 listener 回调返回结果
- 游戏状态异常通过 onStateChanged 回调通知
- 建议在关键操作（如 start、notifyStateChange）后检查回调结果
