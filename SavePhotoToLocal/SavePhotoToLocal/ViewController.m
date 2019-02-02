//
//  ViewController.m
//  SavePhotoToLocal
//


#import "ViewController.h"
#import "ViewController_custom.h"
#import "ViewController_system.h"
@interface ViewController ()
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"长按webview图片到本地";
}

- (IBAction)system:(id)sender {
    ViewController_system *vc = [ViewController_system new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)custom:(id)sender {
    ViewController_custom *vc = [ViewController_custom new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
