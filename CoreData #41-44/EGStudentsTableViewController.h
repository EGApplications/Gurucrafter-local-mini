//
//  EGStudentsTableViewController.h
//  CoreData #41-44
//
//  Created by Евгений Глухов on 31.10.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGCoreDataViewController.h"
#import "EGDataManager.h"
#import "EGStudent.h"

// Папка Students TableView - классы, которые задействуются при работе с отображением студентов и их редактированием.

@interface EGStudentsTableViewController : EGCoreDataViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
