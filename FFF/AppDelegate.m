//
//  AppDelegate.m
//  FFF
//
//  Created by Дмитрий on 27.02.2024.
//

// AppDelegate.m
#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Создание экземпляра ViewController и назначение его корневым контроллером окна
    ViewController *viewController = [[ViewController alloc] init];
    self.window.rootViewController = viewController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
