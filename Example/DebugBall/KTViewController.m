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
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[KTDebugManager installDebugView];
	});
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
