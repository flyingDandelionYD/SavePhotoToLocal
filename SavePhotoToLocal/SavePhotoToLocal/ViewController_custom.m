//
//  ViewController_custom.m
//  SavePhotoToLocal
//


#import "ViewController_custom.h"

#import <WebKit/WebKit.h>

@interface ViewController_custom ()<WKNavigationDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) WKWebView *webView;
@end

@implementation ViewController_custom


/*
 其实系统已经自带了（不能更改格式）
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义长按webview图片到本地";
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0.0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    
    self.webView.navigationDelegate = self;
    
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"savePhoto" ofType:@"html" inDirectory:@"html"];
    [self.webView loadFileURL:[NSURL fileURLWithPath:urlStr] allowingReadAccessToURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];
    
    [self.view addSubview:self.webView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.3;
    longPress.delegate = self;
    [self.webView addGestureRecognizer:longPress];
}


- (void)handleLongPress:(UILongPressGestureRecognizer *)sender{
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchPoint = [sender locationInView:self.webView];
    NSString *imgJS = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    
    [self.webView evaluateJavaScript:imgJS completionHandler:^(id _Nullable imgUrl, NSError * _Nullable error) {
        if (imgUrl) {
            UIAlertController*alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"保存图片到相册"style:UIAlertActionStyleDefault handler:^(UIAlertAction*_Nonnullaction) {
                [self savePhotoToPhotosAlbumWithImg:imgUrl];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)savePhotoToPhotosAlbumWithImg:(NSString *)imgUrl {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
    UIImage *image = [UIImage imageWithData:data];
    if (!image) {
        NSLog(@"读取图片失败");
        return;
    }
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    NSLog(@"%@",msg);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {//长按手势放开

        return YES;
    }else{

        return NO;
    }
}
@end

