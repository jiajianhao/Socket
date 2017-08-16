//
//  ViewController.m
//  ServerClient
//
//  Created by 小雨科技 on 2017/8/16.
//  Copyright © 2017年 jiajianhao. All rights reserved.
//

#import "ViewController.h"
#import <GCDAsyncSocket.h>
#define mDefaultHost @"192.168.31.76"
#define mDefaultPort 8889

@interface ViewController ()<GCDAsyncSocketDelegate>
//客户端socket
@property (nonatomic) GCDAsyncSocket *clientSocket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- Private Method

/**
 发起连接
 */
-(IBAction)startConnect:(id)sender{
    [self.clientSocket connectToHost:mDefaultHost onPort:mDefaultPort withTimeout:-1 error:nil];
}
/**
 发送消息
 */
-(IBAction)sendMessage:(id)sender{
    NSString *newMsg = [NSString stringWithFormat:@"This is Client ! %@",[NSDate date]];
    NSData *data = [newMsg dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
    
}

/**
 接收消息
*/
-(IBAction)receiveMessage:(id)sender{
    [self.clientSocket readDataWithTimeout:5 tag:0];

}
#pragma mark -- GCDAsyncSocket Deleagte
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"连接上%@",host);
    
    [self.clientSocket readDataWithTimeout:-1 tag:0];

    
}

-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    self.clientSocket = newSocket;
    NSLog(@"连接成功");
    NSLog(@"didAcceptNewSocket:-- %@:-%hu",newSocket.connectedHost,newSocket.connectedPort);
    [self.clientSocket readDataWithTimeout:-1 tag:0];
    
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"didReadData: --  %@",text);
    
    [self.clientSocket readDataWithTimeout:-1 tag:0];
    
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"socketDidDisconnect");
    
}

#pragma mark -- Setter/Getter
-(GCDAsyncSocket *)clientSocket{
    if (!_clientSocket) {
        _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];

    }
    return _clientSocket;
}


@end
