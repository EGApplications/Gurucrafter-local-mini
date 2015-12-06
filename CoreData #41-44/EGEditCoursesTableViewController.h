//
//  EGEditCoursesTableViewController.h
//  CoreData #41-44
//
//  Created by Евгений Глухов on 14.11.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGCourse.h"

@interface EGEditCoursesTableViewController : UITableViewController

// Класс для отображения подробной информации о курсе, а также для редактирования текущей информации или создания нового курса.

@property (strong, nonatomic) EGCourse* course;
@property (strong, nonatomic) NSString* editOrAdd;

@end
