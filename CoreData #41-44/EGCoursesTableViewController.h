//
//  EGCoursesTableViewController.h
//  CoreData #41-44
//
//  Created by Евгений Глухов on 02.11.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGCoreDataViewController.h"
#import "EGDataManager.h"
#import "EGCourse+CoreDataProperties.h"

// Метод для отображения информации о курсах в институте.

@interface EGCoursesTableViewController : EGCoreDataViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;


- (IBAction)addButtonAction:(id)sender;

@end
