//
//  EGEditStudentCell.h
//  CoreData #41-44
//
//  Created by Евгений Глухов on 09.11.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EGEditStudentCell : UITableViewCell

// Для студента сделали кастомную ячейка с текстфилдом.

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *studentTextLabel;

@end
