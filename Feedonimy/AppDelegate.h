//
//  AppDelegate.h
//  Feedonimy
//
//  Created by Ashmit Chhabra on 8/14/14.
//  Copyright (c) 2014 ARO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFeedsViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)MyFeedsViewController * viewController;
@end
