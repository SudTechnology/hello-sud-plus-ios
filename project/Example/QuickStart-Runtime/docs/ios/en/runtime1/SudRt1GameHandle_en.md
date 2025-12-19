# ISudRt1GameHandle Interface Documentation

## Overview

`ISudRt1GameHandle` is the core interface for game instance management, responsible for game lifecycle control, state management, and view acquisition.

## Interface Methods

### 1. setStateHandler

**Purpose**: Set the game state listener  
**Method Signature**:

```objective-c
- (void)setStateHandler:(id<ISudRt1GameStateListener>)stateListener;
```

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| stateListener | id<ISudRt1GameStateListener> | Game state listener object |

**Usage Example**:

```objective-c
[gameHandle setStateHandler:self];
```

---

### 2. getGameView

**Purpose**: Get the game view  
**Method Signature**:

```objective-c
- (UIView *)getGameView;
```

**Return Value**:
| Type | Description |
|------|-------------|
| UIView \* | Game rendering view that can be directly added to the view hierarchy |

**Usage Example**:

```objective-c
UIView *gameView = [gameHandle getGameView];
[self.view addSubview:gameView];
```

---

### 3. notifyStateChange

**Purpose**: Send custom user messages (state change notifications) to the game  
**Method Signature**:

```objective-c
- (void)notifyStateChange:(const NSString *)state
                 dataJson:(NSString *)dataJson
                 listener:(nullable ISudListenerNotifyStateChange)listener;
```

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| state | const NSString _ | State name identifying the game state to notify |
| dataJson | NSString _ | State data in JSON format string |
| listener | ISudListenerNotifyStateChange | Callback listener (nullable) |

**Callback Type Definition**:

```objective-c
typedef void (^ISudListenerNotifyStateChange)(NSInteger retCode, NSString *retMsg);
```

**Usage Example**:

```objective-c
[gameHandle notifyStateChange:@"game_custom_message"
                     dataJson:@"{\"type\":\"move\",\"direction\":\"left\"}"
                     listener:^(NSInteger retCode, NSString *retMsg) {
    if (retCode == 0) {
        NSLog(@"State notification successful");
    } else {
        NSLog(@"State notification failed: %@", retMsg);
    }
}];
```

---

### 4. start

**Purpose**: Start the game  
**Method Signature**:

```objective-c
- (void)start;
```

**Description**: Called when starting the game for the first time, initializes game resources and begins execution.

**Usage Example**:

```objective-c
[gameHandle start];
```

---

### 5. play

**Purpose**: Resume game execution (used in conjunction with pause)  
**Method Signature**:

```objective-c
- (void)play;
```

**Description**: Called after the game has been paused, resumes game logic and rendering.

**Usage Example**:

```objective-c
[gameHandle play];
```

---

### 6. pause

**Purpose**: Pause the game (used in conjunction with play)  
**Method Signature**:

```objective-c
- (void)pause;
```

**Description**: Temporarily pauses game execution, suspending game logic and rendering to conserve resources.

**Usage Example**:

```objective-c
[gameHandle pause];
```

---

### 7. destroy

**Purpose**: Destroy the game instance  
**Method Signature**:

```objective-c
- (void)destroy;
```

**Description**: Releases all resources occupied by the game. The game instance cannot be used after destruction.

**Usage Example**:

```objective-c
[gameHandle destroy];
gameHandle = nil;
```

---

## Game State Listener Interface (ISudRt1GameStateListener)

### onStateChanged

**Purpose**: Game state change callback  
**Method Signature**:

```objective-c
-(void)onStateChanged:(NSString*)state
             dataJson:(NSString*)dataJson
               handle:(id<ISudRt1GameStateHandle>)handle;
```

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| state | NSString _ | Game state identifier |
| dataJson | NSString _ | State data in JSON format string |
| handle | id<ISudRt1GameStateHandle> | Game state handler for responding to specific states |

**Implementation Example**:

```objective-c
- (void)onStateChanged:(NSString*)state
             dataJson:(NSString*)dataJson
               handle:(id<ISudRt1GameStateHandle>)handle {

    if ([state isEqualToString:@"game_ready"]) {
        NSLog(@"Game is ready");
        // Handle game ready logic
    } else if ([state isEqualToString:@"game_score"]) {
        // Parse score information
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[dataJson dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        NSInteger score = [data[@"score"] integerValue];
        NSLog(@"Current score: %ld", score);
    }
    // ... Handle other states
}
```

---

## Lifecycle Management Guidelines

### Standard Usage Flow

```objective-c
// 1. Create game instance
id<ISudRt1GameHandle> gameHandle = [SudRT1 createGame:config];

// 2. Set state listener
[gameHandle setStateHandler:self];

// 3. Get and add game view
UIView *gameView = [gameHandle getGameView];
[self.view addSubview:gameView];

// 4. Start the game
[gameHandle start];

// 5. During game execution, pause/play can be called to control suspension/resumption

// 6. Destroy when game ends
[gameHandle destroy];
```

### Important Notes

1. **Thread Safety**: All interface methods should be called on the main thread
2. **Lifecycle**: Ensure proper pairing of game instance creation and destruction to prevent memory leaks
3. **State Listener**: Set the state listener before calling the start method
4. **View Management**: The view returned by getGameView needs to be properly added to the view hierarchy with appropriate frame settings
5. **Resource Release**: All related references should be released after game destruction

### Error Handling

- All asynchronous operations return results through listener callbacks
- Game state exceptions are notified via onStateChanged callbacks
- It is recommended to check callback results after critical operations (such as start, notifyStateChange)

### State Code Definitions

| State Code | Description                            |
| ---------- | -------------------------------------- |
| 0          | Success                                |
| -1         | General failure                        |
| -2         | Invalid parameters                     |
| -3         | Network error                          |
| -4         | Game not initialized                   |
| -5         | Operation not allowed in current state |

### Best Practices

1. Always check return codes from callbacks
2. Implement proper error recovery mechanisms
3. Use appropriate state validation before operations
4. Handle edge cases in state transitions
5. Monitor memory usage during long game sessions
