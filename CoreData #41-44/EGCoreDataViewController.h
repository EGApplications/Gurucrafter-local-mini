//
//  EGCoreDataViewController.h
//  CoreData #41-44
//
//  Created by Евгений Глухов on 16.11.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGDataManager.h"
#import "UITableViewController+EGBackground.h"

// Класс родитель для tableView контроллеров, который содержит классы NSFetchedResultsControllerDelegate

@interface EGCoreDataViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
