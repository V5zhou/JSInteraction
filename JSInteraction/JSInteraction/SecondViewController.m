//
//  SecondViewController.m
//  JSInteraction
//
//  Created by zmz on 2017/6/9.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "SecondViewController.h"
#import "WKWebView+Interaction.h"

@interface SecondViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences.minimumFontSize = 22;
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:self.wkWebView];
    
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Webkit.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [self.wkWebView loadRequest:request];
    
    //注册交互类型
    [self.wkWebView registerScriptTypes:@{@"OCDismiss" : @(WKInterActionOcType_dismiss),
                                          @"OCShowAlert" : @(WKInterActionOcType_alert)}];
    
    [self.wkWebView InterActionToOc:^(WKInterActionOcType functionType, NSDictionary *param) {
        switch (functionType) {
            case WKInterActionOcType_dismiss:
            {
                BOOL isAnimate = [param[@"animate"] boolValue];
                [self dismissViewControllerAnimated:isAnimate completion:nil];
            }
                break;
            case WKInterActionOcType_alert:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"JS去做平方" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alert show];
            }
                break;
            default:
                break;
        }
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2 - 140/2, 300, 140, 30);
    [button setTitle:@"刷新JS" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonAction:(UIButton *)button {
    [self.wkWebView InterActionToJs:@"JSReloadTitle('你点了刷新JS按钮，我没猜错！')"];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //得到输入框
        NSString *value = [[alertView textFieldAtIndex:0] text];
        NSString *jsvaScript = [NSString stringWithFormat:@"JSCaculate(%@)", value];
        [self.wkWebView evaluateJavaScript:jsvaScript completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            
        }];
    }
}

@end
