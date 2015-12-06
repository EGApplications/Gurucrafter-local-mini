//
//  EGTeachersTableViewController.h
//  CoreData #41-44
//
//  Created by Евгений Глухов on 02.11.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGCoreDataViewController.h"
#import "EGDataManager.h"
#import "EGTeacher.h"

@interface EGTeachersTableViewController : EGCoreDataViewController <NSFetchedResultsControllerDelegate>

// Класс для отображения преподавателей

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
