//
//  ViewController.m
//  SocketUdpClient
//
//  Created by 小雨科技 on 2017/8/16.
//  Copyright © 2017年 jiajianhao. All rights reserved.
//

#import "ViewController.h"
#import <GCDAsyncUdpSocket.h>
#import "CommonFuc.h"
#define mHostIP @"192.168.31.35"
#define mPort 8887
@interface ViewController ()<GCDAsyncUdpSocketDelegate>
@property(nonatomic,strong)GCDAsyncUdpSocket*clientSocket;
@property(nonatomic,strong)IBOutlet UITextView*textview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self beginObserver];
    self.textview.text=@"";

}
-(void)dealloc {
    
    [self.clientSocket close];
    self.clientSocket = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- Private Method
/**
 开始监听
 */
-(void)beginObserver{
    NSError * error = nil;
    [self.clientSocket bindToPort:mPort error:&error];
    if (error) {
        NSLog(@"error:%@",error);
    }else {
        NSLog(@"开始监听");
        [self.clientSocket beginReceiving:&error];
    }
    
}
/**
 发送消息
 */
-(void)sendMessage{
//    NSString * ipAddress = [CommonFuc deviceIPAdress];
    NSString *msg = [NSString stringWithFormat:@"This is Client %@",[NSDate date]];
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket sendData:data toHost:mHostIP port:mPort withTimeout:-1 tag:0];
}
#pragma mark -- Udp Socket Deleagate
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address{
    
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    NSString *receive = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"didReceiveData:-- %@",receive);
    NSString *str_receive = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"didReceiveData:---  %@",str_receive);
    NSString *str1 = self.textview.text;
    NSString *showStr = [NSString stringWithFormat:@"%@\n%@",str1,str_receive];
    self.textview.text=showStr;
    [self.textview scrollRangeToVisible:NSMakeRange(self.textview.text.length, 1)];

//    [self.textview scrollRectToVisible:CGRectMake(0, self.textview.contentSize.height-15, self.textview.contentSize.width, 10) animated:YES];

[self.textview setContentOffset:CGPointMake(0.f,self.textview.contentSize.height-self.textview.frame.size.height)];
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
//    [self sendMessage];
    NSLog(@"didSendDataWithTag");
}
#pragma mark -- Button Click
-(IBAction)sendButtonOnCLick:(id)sender{
    [self sendMessage];
}
#pragma mark -- Setter/Getter
-(GCDAsyncUdpSocket *)clientSocket{
    if (!_clientSocket) {
        _clientSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    return _clientSocket;
}


@end
