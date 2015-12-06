//
//  EGLaunchViewController.m
//  CoreData #41-44
//
//  Created by Евгений Глухов on 03.12.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import "EGLaunchViewController.h"

@interface EGLaunchViewController ()

@end

@implementation EGLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIImage* bgImage = [UIImage imageNamed:@"GuruCrafter_bg_color.png"];
    
    UIImageView* bgView = [[UIImageView alloc] initWithImage:bgImage];
    
    [bgView setFrame:self.view.frame];
    
    [self.view addSubview:bgView];
    
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(showApp) userInfo:nil repeats:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showApp {
    
    [self performSegueWithIdentifier:@"showApp" sender:self];
    
}

#pragma mark - Segues 

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
}

@end
