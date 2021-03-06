//
//  WkWebviewViewController.m
//  WuYeYuanGongDuan
//
//  Created by Mac on 2020/6/29.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "WkWebviewViewController.h"
#import <WebKit/WebKit.h>
#import "ZhiBoViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface WkWebviewViewController ()<WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webview;
@end

@implementation WkWebviewViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//    [config.userContentController addScriptMessageHandler:self name:@"app2vue_createLiveRoom"];///创建直播间
//    [config.userContentController addScriptMessageHandler:self name:@"app2vue_getUserInfo"];///获取用户信息
//    [config.userContentController addScriptMessageHandler:self name:@"app2vue_destroyLiveRoom"];///主播销毁直播间
//    [config.userContentController addScriptMessageHandler:self name:@"app2vue_exitLiveRoom"];///观众退出直播间
    
    [config.userContentController addScriptMessageHandler:self name:@"vue2app_saveUserInfo"];
    [config.userContentController addScriptMessageHandler:self name:@"vue2app_getUserInfo"];
    [config.userContentController addScriptMessageHandler:self name:@"vue2app_cleanUserInfo"];
    [config.userContentController addScriptMessageHandler:self name:@"vue2app_centerLiveRoom"];
    [config.userContentController addScriptMessageHandler:self name:@"vue2app_createLiveRoom"];
    
    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    [webview setNavigationDelegate:self];
    [self.view addSubview:webview];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kStatusBarHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
    _webview = webview;
    
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://aimoer.1plus.store/"]]];
    
    //进度条初始化
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kTopHeight, [[UIScreen mainScreen] bounds].size.width, 2)];
    self.progressView.backgroundColor = [UIColor blueColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    [webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
}

/**
 过滤HTML字符串中的图片指定宽度
 
 @param width 宽度
 @return result
 */
- (NSString *)htmlWebAutoImageSizeWidth:(CGFloat)width andvalue:(NSString *)value{
    if (value == nil || value.length == 0) {
        return @"";
    }
    NSString *content = [value stringByReplacingOccurrencesOfString:@"&amp;quot" withString:@"'"];
    content = [content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    content = [content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    content = [content stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    
    
    NSString *html = content;
    NSString * regExpStr = @"<(img|IMG)[^\\<\\>]*>";
    NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:regExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *matches=[regex matchesInString:html
                                    options:0
                                      range:NSMakeRange(0, [html length])];
    
    ///HTML中的<img ...... />数组
    NSMutableArray *imgArray = [NSMutableArray array];
    ///<img src="URL"/>中的URL数组
    NSMutableArray *urlArray = [NSMutableArray array];
    
    for (NSTextCheckingResult *result in matches) {
        NSRange range   = result.range;
        NSString *group = [html substringWithRange:range];
        NSRange srange1 = [group rangeOfString:@"http"];
        NSString *tempString1 = [group substringWithRange:NSMakeRange(srange1.location, group.length - srange1.location)];
        NSRange srange2 = [tempString1 rangeOfString:@"\""];
        NSString *tempString2 = [tempString1 substringWithRange:NSMakeRange(0,srange2.location)];
        [urlArray addObject:tempString2];
        [imgArray addObject:group];
    }
    
    for (int i = 0; i < imgArray.count; i++) {
        NSString *string = imgArray[i];
        
        //[NSDate timeStamp] 这个方法是获取时间戳的
        html = [html stringByReplacingOccurrencesOfString:string withString:[NSString stringWithFormat:@"<img src=\"%@\" title=\"\" alt=\"%.0lf\" width=\"%f\" height=\"auto\">",urlArray[i],[NSDate timeIntervalSinceReferenceDate]+i,width]];
    }
    
    
    return html;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webview.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;

            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKWebView
//在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
//    decisionHandler(WKNavigationActionPolicyCancel);
    // 没有这一句页面就不会显示
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

/// 2 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    

}

/// 4 开始获取到网页内容时返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
    
}

/// 5 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
//   NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
//    [webView evaluateJavaScript:meta completionHandler:^(id _Nullable value, NSError * _Nullable error) {
//        
//    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *startStr = @"app2vue_getUserInfo()";
        [self.webview evaluateJavaScript:startStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"value: %@ error: %@", response, error);
        }];
    });

}

/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"ccc=%@",message.name);
    NSLog(@"ccc1=%@",message.body);
    
//    ///调用方法传递参数
//    NSString *startStr = @"startUploadImgCB('start')";
//    [self.webview evaluateJavaScript:startStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//        NSLog(@"value: %@ error: %@", response, error);
//    }];
    
}


@end
