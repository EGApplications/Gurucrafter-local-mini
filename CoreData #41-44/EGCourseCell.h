//
//  EGCourseCell.h
//  CoreData #41-44
//
//  Created by Евгений Глухов on 14.11.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EGCourseCell : UITableViewCell

// Кастомная ячейка для отображения информации о курсе.

@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UITextField *courseTextField;


@end
