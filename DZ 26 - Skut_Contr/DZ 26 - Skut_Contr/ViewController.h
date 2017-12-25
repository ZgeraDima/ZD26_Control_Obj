//
//  ViewController.h
//  DZ 26 - Skut_Contr
//
//  Created by mac on 25.12.17.
//  Copyright © 2017 Dima Zgera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *ballsAreaView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISwitch *rotationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *scaleSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *translationSwitch;
@property (weak, nonatomic) IBOutlet UISlider *parameterSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegments;
@property (weak, nonatomic) IBOutlet UILabel *parameterLabel;


- (IBAction)actionRotation:(UISwitch *)sender;
- (IBAction)actionScale:(UISwitch *)sender;
- (IBAction)actionTranslation:(UISwitch *)sender;
- (IBAction)actionParameter:(UISlider *)sender;
- (IBAction)actionTypeSegments:(UISegmentedControl *)sender;


@end

