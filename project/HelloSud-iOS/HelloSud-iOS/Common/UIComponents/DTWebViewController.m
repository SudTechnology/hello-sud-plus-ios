//
//  DTWebViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/20.
//

#import "DTWebViewController.h"
#import <WebKit/WebKit.h>

@interface DTWebViewController ()<WKNavigationDelegate>
@property(nonatomic, strong)WKWebView *webView;
@end

@implementation DTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    [self.webView removeObserver:self
                      forKeyPath:NSStringFromSelector(@selector(title))];
}

- (void)hsAddViews {
    [super hsAddViews];
    [self.view addSubview:self.webView];
}

- (void)hsLayoutViews {
    [super hsLayoutViews];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)hsConfigEvents {
    [super hsConfigEvents];
    //添加监测网页标题title的观察者
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
}

//kvo 监听进度 必须实现此方法
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    if([keyPath isEqualToString:@"title"]
       && object == _webView){
        self.navigationItem.title = _webView.title;
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (void)setUrl:(NSString *)url {
    _url = url;
    if (url.length > 0) {
        NSURLRequest *req = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
        [self.webView loadRequest:req];
    }
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
        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
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
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    }
    return _webView;
}

#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    self.title = webView.title;
}
@end
