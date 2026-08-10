//
//  main.m
//  kawkaw
//
//  entry point
//

#import <UIKit/UIKit.h>
#import "kawkawAppDelegate.h"

int main(int argc, char *argv[])
{
    NSString *appDelegateClassName;
    @autoreleasepool {
        appDelegateClassName = NSStringFromClass([kawkawAppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
