//
//  ViewController.m
//  Reproduce_Bad_Network
//
//  Created by g9202 on 2024/1/15.
//

#import "ViewController.h"

@import YMHTTP;

@interface ViewController () <YMURLSessionDataDelegate, NSURLSessionDataDelegate>
@property (nonatomic, strong) YMURLSession *ymSession;
@property (nonatomic, strong) YMURLSessionTask *ymTask;

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, strong) NSURLSessionTask *urlTask;

@property (nonatomic, assign) NSUInteger totalDownload;
@property (nonatomic, assign) NSDate *startDate;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)startWithUrlSession:(id)sender {
    NSString *fileURL = @"<#file url #>";
    self.totalDownload = 0;
    self.startDate = [NSDate now];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.networkServiceType = NSURLNetworkServiceTypeVideo;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    self.urlSession = session;
    
    NSURL *requestURL = [NSURL URLWithString:fileURL];
    self.urlTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:requestURL]];
    [self.urlTask resume];
    
    NSLog(@"startWithUrlSession");

    // 1️⃣ try
    // [2024-01-15 15:43:32.022138+08:00] startWithUrlSession
    // ...
    // [2024-01-15 15:45:59.840784+08:00] end, total: 8353634 bytes, speed: 55.181256 kb/s
    
    // 2️⃣ try
    // [2024-01-15 15:48:41.404968+08:00] startWithUrlSession
    // ...
    // [2024-01-15 15:51:01.249930+08:00] end, total: 8353634 bytes, speed: 58.327492 kb/s
}

- (IBAction)startWithOther:(id)sender {
    NSString *fileURL = @"<#file url #>";
    self.totalDownload = 0;
    self.startDate = [NSDate now];

    YMURLSessionConfiguration *config = [YMURLSessionConfiguration defaultSessionConfiguration];
    YMURLSession *session = [YMURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    self.ymSession = session;

    NSURL *requestURL = [NSURL URLWithString:fileURL];
    self.ymTask = [session taskWithRequest:[NSURLRequest requestWithURL:requestURL]];
    [self.ymTask resume];
    
    NSLog(@"startWithOther");
    
    // 1️⃣ try
    // [2024-01-15 15:40:20.676186+08:00] startWithOther
    // ...
    // [2024-01-15 15:41:45.479572+08:00] end, total: 8353634 bytes, speed: 96.168389 kb/s
    
    // 2️⃣ try
    // [2024-01-15 15:46:40.655436+08:00] startWithOther
    // ...
    // [2024-01-15 15:47:43.026212+08:00]end, total: 8353634 bytes, speed: 130.752044 kb/s
}

#pragma mark - YMURLSessionDataDelegate
-(void)YMURLSession:(YMURLSession *)session task:(YMURLSessionTask *)task didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(YMURLSessionResponseDisposition))completionHandler {
    completionHandler(YMURLSessionResponseAllow);
    NSLog(@"didReceiveResponse %ld", [((NSHTTPURLResponse *)response) statusCode]);
}

- (void)YMURLSession:(YMURLSession *)session task:(YMURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    NSLog(@"willPerformHTTPRedirection %ld", [((NSHTTPURLResponse *)response) statusCode]);
    completionHandler(request);
}

- (void)YMURLSession:(YMURLSession *)session task:(YMURLSessionTask *)task didReceiveData:(NSData *)data {
    _totalDownload += data.length;
    NSLog(@"didReceiveData %ld bytes, total: %ld bytes", data.length, _totalDownload);
}

- (void)YMURLSession:(YMURLSession *)session task:(YMURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"end, total: %ld bytes, speed: %lf kb/s", _totalDownload, _totalDownload / 1024 / [[NSDate now] timeIntervalSinceDate:self.startDate]);
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
   completionHandler(NSURLSessionResponseAllow);
   NSLog(@"didReceiveResponse %ld", [((NSHTTPURLResponse *)response) statusCode]);
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
   NSLog(@"willPerformHTTPRedirection %ld", [((NSHTTPURLResponse *)response) statusCode]);
   completionHandler(request);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
   _totalDownload += data.length;
   NSLog(@"didReceiveData %ld bytes, total: %ld bytes", data.length, _totalDownload);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"end, total: %ld bytes, speed: %lf kb/s", _totalDownload, _totalDownload / 1024 / [[NSDate now] timeIntervalSinceDate:self.startDate]);
}


@end
