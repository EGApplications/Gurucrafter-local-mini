//
//  UITableViewController+EGBackground.m
//  CoreData #41-44
//
//  Created by Евгений Глухов on 03.12.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import "UITableViewController+EGBackground.h"

@implementation UITableViewController (EGBackground)

- (void) blurBackground {
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UIImage* bgImage = [UIImage imageNamed:@"GuruCrafter_bg_color.png"];
    
    UIBlurEffect* blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    
    UIVisualEffectView* blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    UIImageView* tableBackgroundView = [[UIImageView alloc] initWithImage:bgImage];
    
    [tableBackgroundView setFrame:self.tableView.frame];
    
    blurView.frame = tableBackgroundView.bounds;
    
    [tableBackgroundView addSubview:blurView];
    
//        [self.tableView insertSubview:tableBackgroundView atIndex:0];
    
    [self.tableView setBackgroundView:tableBackgroundView];
    
    
}



@end
