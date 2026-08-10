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
//  kawkawAppDelegate.m
//  kawkaw
//

#import "kawkawAppDelegate.h"
#import "kawkawExploit.h"

@interface ViewController : UIViewController
@property (nonatomic, strong) UITextView *logView;
@property (nonatomic, strong) UIButton *goButton;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"kawkaw";

    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.statusLabel.textColor = [UIColor secondaryLabelColor];
    self.statusLabel.text = @"idle";
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.statusLabel];

    self.logView = [[UITextView alloc] init];
    self.logView.editable = NO;
    self.logView.font = [UIFont monospacedSystemFontOfSize:11 weight:UIFontWeightRegular];
    self.logView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.logView.text = @"tap Go to run exploit\n";
    self.logView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.logView];

    self.goButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.goButton setTitle:@"Go" forState:UIControlStateNormal];
    self.goButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.goButton addTarget:self action:@selector(goTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.goButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.goButton];

    UILayoutGuide *g = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [self.statusLabel.topAnchor constraintEqualToAnchor:g.topAnchor constant:8],
        [self.statusLabel.centerXAnchor constraintEqualToAnchor:g.centerXAnchor],
        [self.logView.topAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:8],
        [self.logView.leadingAnchor constraintEqualToAnchor:g.leadingAnchor constant:12],
        [self.logView.trailingAnchor constraintEqualToAnchor:g.trailingAnchor constant:-12],
        [self.goButton.topAnchor constraintEqualToAnchor:self.logView.bottomAnchor constant:12],
        [self.goButton.centerXAnchor constraintEqualToAnchor:g.centerXAnchor],
        [self.goButton.widthAnchor constraintEqualToConstant:120],
        [self.goButton.heightAnchor constraintEqualToConstant:44],
        [self.goButton.bottomAnchor constraintLessThanOrEqualToAnchor:g.bottomAnchor constant:-12],
    ]];
}

- (void)setStatus:(NSString *)text color:(UIColor *)color
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = text;
        self.statusLabel.textColor = color;
    });
}

- (void)refreshLog
{
    kawkawExploit *e = [kawkawExploit shared];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.logView.text = e.logText ?: @"";
        [self.logView scrollRangeToVisible:NSMakeRange(self.logView.text.length - 1, 1)];
    });
}

- (void)goTapped:(UIButton *)sender
{
    kawkawExploit *e = [kawkawExploit shared];
    if (e.state == KawkawExploitStateRunning) return;

    [self setStatus:@"running..." color:[UIColor systemOrangeColor]];
    [e runExploit];

    [NSTimer scheduledTimerWithTimeInterval:0.3 repeats:YES block:^(NSTimer *t) {
        [self refreshLog];
        kawkawExploit *eng = [kawkawExploit shared];
        if (eng.state == KawkawExploitStateSuccess) {
            [t invalidate];
            [self setStatus:[NSString stringWithFormat:@"rw ready  base=0x%llx", eng.kernelBase] color:[UIColor systemGreenColor]];
        } else if (eng.state == KawkawExploitStateFailed) {
            [t invalidate];
            [self setStatus:@"failed" color:[UIColor systemRedColor]];
        }
    }];
}

@end

@implementation kawkawAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
