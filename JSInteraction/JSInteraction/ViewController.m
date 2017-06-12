//
//  ViewController.m
//  JSInteraction
//
//  Created by zmz on 2017/6/9.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "UIWebView+Interaction.h"

@interface ViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"JavaScriptCore.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [self.webView loadRequest:request];
}

//
- (IBAction)buttonClick:(id)sender {
    [_webView InterActionToJs:@"alertMobile('15625298071')"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.webView InterActionToOc:^(InterActionOcType functionType, NSDictionary *param) {
        switch (functionType) {
            case InterActionOcType_alert:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:param[@"title"] message:param[@"content"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
                break;
            case InterActionOcType_present:
            {
                self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                Class Cls = NSClassFromString(param[@"toController"]);
                BOOL isAnimate = [param[@"animate"] boolValue];
                UIViewController *ctl = [[Cls alloc] init];
                [self presentViewController:ctl animated:isAnimate completion:nil];
            }
                break;
                
            default:
                break;
        }
    }];
}

@end
