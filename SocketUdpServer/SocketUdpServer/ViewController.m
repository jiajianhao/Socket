//
//  ViewController.m
//  SocketUdpServer
//
//  Created by 小雨科技 on 2017/8/16.
//  Copyright © 2017年 jiajianhao. All rights reserved.
//

#import "ViewController.h"
#import <GCDAsyncUdpSocket.h>
#define mProt 8887
@interface ViewController ()<GCDAsyncUdpSocketDelegate>
@property (strong, nonatomic)GCDAsyncUdpSocket * udpSocket;
@property (strong, nonatomic)NSData * clientAddress;
@property (strong, nonatomic)IBOutlet UITextView *textview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self beginObserver];
    self.textview.text=@"";
}
-(void)dealloc {
    
    [self.udpSocket close];
    self.udpSocket = nil;
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
    [self.udpSocket bindToPort:mProt error:&error];
    if (error) {
        NSLog(@"error:%@",error);
    }else {
        NSLog(@"开始监听");
        [self.udpSocket beginReceiving:&error];
    }
 
}

/**
 发送消息
 */
-(void)sendMessage{
    NSString *msg = [NSString stringWithFormat:@"This is Server %@",[NSDate date]];
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [self.udpSocket sendData:data toHost:[GCDAsyncUdpSocket hostFromAddress:self.clientAddress] port:[GCDAsyncUdpSocket portFromAddress:self.clientAddress] withTimeout:-1 tag:0];
 }
#pragma mark -- UdpSocket Delegate
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address{
    self.clientAddress = [NSData dataWithData:address];
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    self.clientAddress = [NSData dataWithData:address];
    NSString *str_address = [[NSString alloc]initWithData:address encoding:NSUTF8StringEncoding];
    NSLog(@"didReceiveData address:---  %@",str_address);

    NSString *str_receive = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString *str1 = self.textview.text;
    NSString *showStr = [NSString stringWithFormat:@"%@\n%@",str1,str_receive];
    self.textview.text=showStr;
    [self.textview scrollRangeToVisible:NSMakeRange(self.textview.text.length, 1)];
    [self sendMessage];
    
}


#pragma mark --Setter/Getter
-(GCDAsyncUdpSocket *)udpSocket{
    if (!_udpSocket) {
        _udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];

    }
    return _udpSocket;
}
@end
