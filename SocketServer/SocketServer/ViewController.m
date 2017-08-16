//
//  ViewController.m
//  SocketServer
//
//  Created by 小雨科技 on 2017/8/16.
//  Copyright © 2017年 jiajianhao. All rights reserved.
//

#import "ViewController.h"
#import <GCDAsyncSocket.h>
#define mDefaultPort 8889
@interface ViewController ()<GCDAsyncSocketDelegate>
//服务器socket
@property (nonatomic) GCDAsyncSocket *serverSocket;
//客户端socket
@property (nonatomic) GCDAsyncSocket *clientSocket;
@end

@implementation ViewController
#pragma mark -- Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    [self beginObserver];
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
    NSError *error = nil;
    BOOL result = [self.serverSocket acceptOnPort:mDefaultPort error:&error];
    if (result && error == nil) {
        NSLog(@"开始监听网络");
    }

}

/**
 发送消息
 */
-(void)sendMessage{
    NSString *newMsg = [NSString stringWithFormat:@"This is Server ! %@",[NSDate date]];
    NSData *data = [newMsg dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
    
}
#pragma mark -- GCDAsyncSocket Deleagte
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"连接上%@",host);
    
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

    [self sendMessage];
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"socketDidDisconnect");
    
}

#pragma mark -- Setter/Getter
-(GCDAsyncSocket *)serverSocket{
    if (!_serverSocket) {
        _serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _serverSocket;
}








@end
