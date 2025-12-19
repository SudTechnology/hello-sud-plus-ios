# SudRt2GameHandle API Reference

`SudRt2GameHandle` is an interface class implemented in **Cocos Runtime**, defining how the application layer interacts with the game.
An instance of this interface is created by the **Cocos Runtime instance** and returned to the application layer.
The application layer is responsible for storing, using, and destroying this instance.

Unless otherwise specified, all functions, interfaces, and constants described in this document belong to `SudRt2GameHandle`.
All APIs should be called **on the UI thread**.

---

## Game Handle Lifecycle

A `Game Handle` instance is created through the Cocos Runtime API
`createGameHandleWithOptions:completion:`.
Once created, you can control the game instance state using lifecycle operation functions, and receive state change notifications via the `SudRt2GameStateChangeListener` interface.

### Lifecycle States

1. **UNAVAILABLE**
   The game runtime environment is not yet initialized.
   When a Game Handle is first created, it starts in this state.
   Game startup parameters should be configured during this state.

2. **WAITING**
   The game runtime environment is ready but not running.
   When the game view is not visible, it should remain in this state.

3. **RUNNING**
   The game is running but user input is disabled.
   When the game is visible but the window does not have focus, this state should be used.

4. **PLAYING**
   The game is running and actively processing user interactions.
   This is the normal gameplay state.

---

## Game Handle Lifecycle APIs

### create

```objc
- (void)create
```

Creates the game runtime environment.
Upon successful execution, the game instance transitions to the **`WAITING`** state.

This method can only succeed if:

- Game startup parameters have been properly configured, and
- No runtime environment currently exists.

---

### start:

```objc
- (void)start:(NSString *)onShowMsg
```

Starts the game runtime environment.
Upon success, the game instance transitions to the **`RUNNING`** state and game scripts begin executing.

This API should be called when launching the game or when switching from background to foreground.

**⚠️ Note:**

1. After calling this method, you should use `getGameView` to obtain the `GameView` instance.
   When resizing the `GameView`, the runtime will notify the game that the window size has changed.
   If the game does not handle resize events properly, this may result in incorrect rendering or blank display.

**Parameters**

| Name        | Type         | Description                                                                           |
| :---------- | :----------- | :------------------------------------------------------------------------------------ |
| `onShowMsg` | `NSString *` | Message passed to the JS `onShow` callback when the app is brought to the foreground. |

---

### play

```objc
- (void)play
```

Enables the game environment to process player input events.
Upon success, the game transitions to the **`PLAYING`** state.

Call this method only when the game window is visible and has input focus.

---

### pause

```objc
- (void)pause
```

Pauses user input processing in the game environment.
Upon success, the game transitions back to the **`RUNNING`** state.

Use this method when the game remains visible but loses input focus.

---

### stop:

```objc
- (void)stop:(NSString *)onHideMsg
```

Stops script execution in the game environment.
Upon success, the game transitions to the **`WAITING`** state.

This method should be invoked when the game moves from foreground to background or when stopping gameplay.

**Parameters**

| Name        | Type         | Description                                                                        |
| :---------- | :----------- | :--------------------------------------------------------------------------------- |
| `onHideMsg` | `NSString *` | Message passed to the JS `onHide` callback when the app is sent to the background. |

---

### destroy

```objc
- (void)destroy
```

Destroys the game runtime environment.
Upon success, the game transitions to the **`UNAVAILABLE`** state and all associated resources are released.

Call this method when the game is no longer needed.

## Game Handle Event Listener APIs

Event listeners are used to handle callbacks from the game runtime, such as custom commands, game state changes, and rendering frame events.
These listener interfaces allow the application layer to respond to game events in real time.

---

### setCustomCommandListener:

```objc
- (void)setCustomCommandListener:(id<SudCustomCommandListener>)listener
```

Registers a custom command listener to receive messages sent from the game.
When the game executes `sud.customCommand(cmd, data)` in JavaScript, this listener is triggered.

**Parameters**

| Name       | Type                           | Description                                               |
| :--------- | :----------------------------- | :-------------------------------------------------------- |
| `listener` | `id<SudCustomCommandListener>` | The listener instance that handles custom command events. |

---

### setGameDrawFrameListener:

```objc
- (void)setGameDrawFrameListener:(id<SudGameDrawFrameListener>)listener
```

Registers a frame rendering listener that receives notifications when the game view completes drawing a frame.
This listener is useful for performance monitoring or frame synchronization.

**Parameters**

| Name       | Type                           | Description                                           |
| :--------- | :----------------------------- | :---------------------------------------------------- |
| `listener` | `id<SudGameDrawFrameListener>` | The listener instance that handles frame draw events. |

---

### setGameStateChangeListener:

```objc
- (void)setGameStateChangeListener:(id<SudGameStateChangeListener>)listener
```

Registers a listener to receive notifications when the game state changes.
This listener is triggered when the game transitions between **UNAVAILABLE**, **WAITING**, **RUNNING**, or **PLAYING** states.

**Parameters**

| Name       | Type                             | Description                                                     |
| :--------- | :------------------------------- | :-------------------------------------------------------------- |
| `listener` | `id<SudGameStateChangeListener>` | The listener instance that receives state change notifications. |

---

### setGameNotifyListener:

```objc
- (void)setGameNotifyListener:(id<SudGameNotifyListener>)listener
```

Registers a listener to handle notification events from the game.
Notifications include system messages, user actions, and internal game events.

**Parameters**

| Name       | Type                        | Description                                              |
| :--------- | :-------------------------- | :------------------------------------------------------- |
| `listener` | `id<SudGameNotifyListener>` | The listener instance that processes game notifications. |

---

### setGameViewListener:

```objc
- (void)setGameViewListener:(id<SudGameViewListener>)listener
```

Registers a listener for game view events, such as creation, destruction, and resizing.
Use this listener to synchronize UI or resource changes with the game view lifecycle.

**Parameters**

| Name       | Type                      | Description                                                    |
| :--------- | :------------------------ | :------------------------------------------------------------- |
| `listener` | `id<SudGameViewListener>` | The listener instance that handles game view lifecycle events. |

---

### setGameLogListener:

```objc
- (void)setGameLogListener:(id<SudGameLogListener>)listener
```

Registers a listener for log messages generated by the game runtime.
Use this for debugging or to capture logs from within the embedded game environment.

**Parameters**

| Name       | Type                     | Description                                             |
| :--------- | :----------------------- | :------------------------------------------------------ |
| `listener` | `id<SudGameLogListener>` | The listener instance that receives runtime log output. |

---

### setGameVolumeListener:

```objc
- (void)setGameVolumeListener:(id<SudGameVolumeListener>)listener
```

Registers a listener to monitor volume level changes in the game.
Useful for audio visualization or dynamic sound balancing.

**Parameters**

| Name       | Type                        | Description                                                   |
| :--------- | :-------------------------- | :------------------------------------------------------------ |
| `listener` | `id<SudGameVolumeListener>` | The listener instance that handles game volume change events. |

## Game Handle Other APIs

These APIs provide utility and control operations for interacting with the game engine at runtime, including calling JavaScript methods, retrieving views, and obtaining game state data.

---

### callJsMethod:params:

```objc
- (void)callJsMethod:(NSString *)method params:(NSString *)params
```

Calls a JavaScript method within the game runtime environment.
This allows the native host (Objective-C / Swift) to communicate directly with the embedded game logic.

**Parameters**

| Name     | Type         | Description                                     |
| :------- | :----------- | :---------------------------------------------- |
| `method` | `NSString *` | The name of the JavaScript method to call.      |
| `params` | `NSString *` | The JSON string representing method parameters. |

**Example**

```swift
gameHandle.callJsMethod("onNativeCommand", params: "{\"cmd\":\"pauseGame\"}")
```

---

### getGameView

```objc
- (UIView *)getGameView
```

Returns the current game view used to render the game’s visual content.
The view can be added directly to your app’s UI hierarchy.

**Returns**

| Type       | Description                       |
| :--------- | :-------------------------------- |
| `UIView *` | The game rendering view instance. |

**Example**

```swift
let gameView = gameHandle.getGameView()
view.addSubview(gameView)
```

---

### getState

```objc
- (NSInteger)getState
```

Retrieves the current game state value.
The returned integer corresponds to predefined game state constants.

**Game State Values**

| Constant | Description         |
| :------- | :------------------ |
| `0`      | Game unavailable    |
| `1`      | Waiting for players |
| `2`      | Running             |
| `3`      | Playing             |

**Returns**

| Type        | Description             |
| :---------- | :---------------------- |
| `NSInteger` | The current game state. |

---

### isPaused

```objc
- (BOOL)isPaused
```

Checks whether the game is currently paused.

**Returns**

| Type   | Description                                  |
| :----- | :------------------------------------------- |
| `BOOL` | `YES` if the game is paused, otherwise `NO`. |

---

### setVolume:

```objc
- (void)setVolume:(float)volume
```

Sets the global game audio volume level.
The valid range is from `0.0` (mute) to `1.0` (maximum volume).

**Parameters**

| Name     | Type    | Description                                 |
| :------- | :------ | :------------------------------------------ |
| `volume` | `float` | Audio volume level between `0.0` and `1.0`. |

---

### getVolume

```objc
- (float)getVolume
```

Gets the current global audio volume level.

**Returns**

| Type    | Description                     |
| :------ | :------------------------------ |
| `float` | The current audio volume level. |

---

### getAppId

```objc
- (NSString *)getAppId
```

Retrieves the unique App ID used to initialize the game runtime.

**Returns**

| Type         | Description         |
| :----------- | :------------------ |
| `NSString *` | The current App ID. |

---

### getGameId

```objc
- (NSString *)getGameId
```

Retrieves the unique Game ID currently loaded in the runtime.

**Returns**

| Type         | Description          |
| :----------- | :------------------- |
| `NSString *` | The current Game ID. |

---

### getGameVersion

```objc
- (NSString *)getGameVersion
```

Gets the version of the currently loaded game.

**Returns**

| Type         | Description              |
| :----------- | :----------------------- |
| `NSString *` | The game version string. |

---

### getSdkVersion

```objc
- (NSString *)getSdkVersion
```

Gets the version of the integrated **Sud Game SDK**.

**Returns**

| Type         | Description             |
| :----------- | :---------------------- |
| `NSString *` | The SDK version string. |

---

### isSupportBackground

```objc
- (BOOL)isSupportBackground
```

Determines whether the game supports background running mode.

**Returns**

| Type   | Description                                            |
| :----- | :----------------------------------------------------- |
| `BOOL` | `YES` if background mode is supported, otherwise `NO`. |
