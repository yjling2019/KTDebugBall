//
//  KTViewController.m
//  DebugBall
//
//  Created by ling on 07/13/2022.
//  Copyright (c) 2022 ling. All rights reserved.
//

#import "KTViewController.h"
#import "KTDebugManager.h"

@interface KTViewController ()

@end

@implementation KTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.view.backgroundColor = [UIColor redColor];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[[KTDebugManager sharedManager] autoEnableOnDebug];
	[[KTDebugManager sharedManager] checkDebugBallStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
