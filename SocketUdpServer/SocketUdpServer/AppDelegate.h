//
//  AppDelegate.h
//  SocketUdpServer
//
//  Created by 小雨科技 on 2017/8/16.
//  Copyright © 2017年 jiajianhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

