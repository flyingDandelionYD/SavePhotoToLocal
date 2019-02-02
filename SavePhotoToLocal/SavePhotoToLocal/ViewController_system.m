//
//  ViewController_system.m
//  SavePhotoToLocal
//


#import "ViewController_system.h"
#import <WebKit/WebKit.h>

@interface ViewController_system ()
@property (nonatomic,strong) WKWebView *webView;
@end

@implementation ViewController_system

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统长按webview图片到本地";
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0.0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"savePhoto" ofType:@"html" inDirectory:@"html"];
    [self.webView loadFileURL:[NSURL fileURLWithPath:urlStr] allowingReadAccessToURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];
    
    [self.view addSubview:self.webView];
}

@end
