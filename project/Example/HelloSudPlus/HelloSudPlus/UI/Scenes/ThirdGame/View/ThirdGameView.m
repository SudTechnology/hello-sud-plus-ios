//
//  ThirdGameView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2023/12/13.
//  Copyright © 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "ThirdGameView.h"
#import <WebKit/WebKit.h>

@interface GameWebView : WKWebView

@end

@implementation GameWebView

//- (UIEdgeInsets)safeAreaInsets {
//    return UIEdgeInsetsZero;
//}

@end


@interface ThirdGameView()<WKUIDelegate>
@property(nonatomic, strong)WKWebView *webView;
@end


/// 三方游戏视图
@implementation ThirdGameView

- (void)dtAddViews {
    [super dtAddViews];
    
}

- (void)dtLayoutViews {
    [super dtLayoutViews];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = UIColor.clearColor;
}


/// 加载游戏
/// - Parameter url: url 游戏链接
- (void)loadGame:(NSString *)url {
    if (!_webView) {
        [self addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    if (url.length > 0) {
        NSURLRequest *req = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
        [self.webView loadRequest:req];
    }
}

- (void)destryGame {
    if (!_webView) {
        return;
    }
    [_webView removeFromSuperview];
    _webView = nil;
}

/// 更新金币
- (void)updateCoin {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString* str = @"updateCoin()";
        // 這裏 修改名字和參數
        [self.webView evaluateJavaScript:str completionHandler:^(id response, NSError *error) {
            DDLogDebug(@"evaluateJavaScript error:%@", error.debugDescription);
        }];
    });
}

#pragma mark lazy
- (WKWebView *)webView {
    if (_webView == nil) {
        WKWebViewConfiguration *config = WKWebViewConfiguration.new;
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放/Users/kaniel/Downloads/IMG_E33A87519F32-1.jpeg
        config.requiresUserActionForMediaPlayback = YES;
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
        //设置请求的User-Agent信息中应用程序名称 iOS9后可用
//        config.applicationNameForUserAgent = @"ChinaDailyForiPad";
//        //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
//        WeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
//        //这个类主要用来做native与JavaScript的交互管理
//        WKUserContentController * wkUController = [[WKUserContentController alloc] init];
//        //注册一个name为jsToOcNoPrams的js方法
//        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcNoPrams"];
//        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcWithPrams"];
//        config.userContentController = wkUController;

        
        WKUserContentController* wcc = [[WKUserContentController alloc] init];

        // 绑定方法名
        [wcc addScriptMessageHandler:self name:@"closeGame"];
        [wcc addScriptMessageHandler:self name:@"pay"];
        
        config.userContentController = wcc;
        if (@available(iOS 10.0, *)) {
            // WKAudiovisualMediaTypeNone 音视频的播放不需要用户手势触发, 即为自动播放
            config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
        } else {
            config.requiresUserActionForMediaPlayback = NO;
        }

        _webView = [[GameWebView alloc]initWithFrame:CGRectZero configuration:config];
        [_webView setOpaque:NO];
        _webView.backgroundColor = UIColor.clearColor;
        [_webView setUIDelegate:self];
        
        
    }
    return _webView;
}



// 绑定回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSString* method = [NSString stringWithFormat:@"%@:", message.name];
    SEL selector = NSSelectorFromString(method);
    if([self respondsToSelector:selector]){
        // 使用反映射
        [self performSelector:selector withObject:message.body];
    }else{
        NSLog(@"未實現方法 : %@ --> %@", message.name, message.body);
    }
}

// 关闭游戏
- (void)closeGame:(NSDictionary*)args {
    DDLogDebug(@"webview closeGame:%@", args);
    if (self.onCloseGameBlock) {
        self.onCloseGameBlock();
    }
}

// 显示充值界面
- (void)pay:(NSDictionary*)args {
    DDLogDebug(@"webview pay:%@", args);
    if (self.onGamePayBlock) {
        self.onGamePayBlock();
    }
}



@end
