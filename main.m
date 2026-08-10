//
//  kawkaw — SPTM customization tools
//  Copyright (C) 2026 kawkaw
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
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
