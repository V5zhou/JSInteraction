# JSInteraction
这是一个OC与JS交互的封装，包含有两套交互方式：UIWebView+UIWebViewDelegate、WKWebView+WKScriptMessageHandler。旧的- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType交互方式未添加，觉得不如这两种用起来方便。
