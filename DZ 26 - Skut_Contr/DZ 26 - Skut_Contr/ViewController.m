//
//  ViewController.m
//  DZ 26 - Skut_Contr
//
//  Created by mac on 25.12.17.
//  Copyright © 2017 Dima Zgera. All rights reserved.
//

#import "ViewController.h"

typedef enum {
    DZTypeHandBall,
    DZTypeVolleyBall,
    DZTypeBasketBall
} DZType;

typedef enum {
    DZChoosenParameterNone,
    DZChoosenParameterRotation,
    DZChoosenParameterScale,
    DZChoosenParameterTranslation
} DZChoosenParameter;

@interface ViewController ()

@property (assign, nonatomic) CGFloat rotationSpeed;
@property (assign, nonatomic) CGFloat scale;
@property (assign, nonatomic) CGFloat translationSpeed;
@property (assign, nonatomic) DZChoosenParameter choosenParameter;
@property (assign, nonatomic) CGFloat animationTime;
@property (strong, nonatomic) NSMutableArray* rotationKeys;
@property (strong, nonatomic) NSMutableArray* translationKeys;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animationTime = 2.f;
    self.choosenParameter = DZChoosenParameterNone;
    self.rotationSpeed = self.parameterSlider.value;
    self.scale = self.parameterSlider.value;
    self.translationSpeed = self.parameterSlider.value;
    
    [self setImageToImageView];
    [self enableSladerByParameter:self.choosenParameter];
}

- (void)setImageToImageView {
    switch (self.typeSegments.selectedSegmentIndex) {
        case DZTypeHandBall:
            self.imageView.image = [UIImage imageNamed:@"HandBall.jpg"];
            break;
        case DZTypeVolleyBall:
            self.imageView.image = [UIImage imageNamed:@"VolleyBall.jpg"];
            break;
        case DZTypeBasketBall:
            self.imageView.image = [UIImage imageNamed:@"BasketBall.jpg"];
            break;
        default:
            break;
    }
}

- (void)enableSladerByParameter:(DZChoosenParameter) parameter {
    switch (parameter) {
        case DZChoosenParameterNone:
            self.parameterSlider.enabled = NO;
            self.parameterLabel.text = [NSString stringWithFormat:@"Not selected"];
            break;
        case DZChoosenParameterRotation:
            self.parameterSlider.enabled = YES;
            self.parameterLabel.text = [NSString stringWithFormat:@"Rotation speed:"];
            self.parameterSlider.value = self.rotationSpeed;
            break;
        case DZChoosenParameterScale:
            self.parameterSlider.enabled = YES;
            self.parameterLabel.text = [NSString stringWithFormat:@"Scale:"];
            self.parameterSlider.value = self.scale;
            break;
        case DZChoosenParameterTranslation:
            self.parameterSlider.enabled = YES;
            self.parameterLabel.text = [NSString stringWithFormat:@"Translation speed:"];
            self.parameterSlider.value = self.translationSpeed;
            break;
    }
}

- (DZChoosenParameter)findEnabledParameter {
    if (self.rotationSwitch.isOn) {
        return DZChoosenParameterRotation;
    } else if (self.scaleSwitch.isOn) {
        return DZChoosenParameterScale;
    } else if (self.translationSwitch.isOn) {
        return DZChoosenParameterTranslation;
    } else {
        return DZChoosenParameterNone;
    }
}

- (void)actionSwitchType:(DZChoosenParameter) parameter sender:(UISwitch *) sender {
    if (sender.isOn) {
        self.choosenParameter = parameter;
    } else {
        self.choosenParameter = [self findEnabledParameter];
    }
    [self enableSladerByParameter:self.choosenParameter];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    });
}

- (void) setValue:(CGFloat) value byParameter:(DZChoosenParameter) parameter {
    switch (parameter) {
        case DZChoosenParameterNone:
            break;
        case DZChoosenParameterRotation:
            self.rotationSpeed = value;
            break;
        case DZChoosenParameterScale:
            self.scale = value;
            [self setScale];
            break;
        case DZChoosenParameterTranslation:
            self.translationSpeed = value;
            break;
    }
}

# pragma mark - Animations

- (void) animateRotation {
    
    if (self.rotationSwitch.isOn){
        
        [UIView animateWithDuration: self.animationTime / (self.rotationSpeed * 16)
                              delay: 0
                            options:    UIViewAnimationOptionBeginFromCurrentState |
         UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, (M_PI_2 / 4));
                         }
                         completion:^(BOOL finished) {
                             [self animateRotation];
                         }];
    }
}

- (void)setScale {
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGAffineTransform scale = CGAffineTransformMakeScale(self.scale, self.scale);
                         self.imageView.transform = scale;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}


- (void)animateTranslation {
    if (self.translationSwitch.isOn){
        
        CGFloat destinationX;
        //CGFloat destinationY = CGRectGetMidY(self.ballsAreaView.bounds);
        
        CGFloat destinationY = [self randomCGFloatFrom:CGRectGetWidth(self.imageView.frame) / 2 to:CGRectGetMaxY(self.ballsAreaView.bounds) - CGRectGetWidth(self.imageView.frame) / 2];
        
        if (CGRectGetMidX(self.imageView.frame) > CGRectGetMidX(self.ballsAreaView.bounds)) {
            destinationX = CGRectGetMinX(self.ballsAreaView.bounds) + CGRectGetWidth(self.imageView.frame) / 2;
        } else {
            destinationX = CGRectGetMaxX(self.ballsAreaView.bounds) - CGRectGetWidth(self.imageView.frame) / 2;
        }
        
        CGPoint destination = CGPointMake(destinationX, destinationY);
        
        [UIView animateWithDuration:self.animationTime / self.translationSpeed
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState |
         UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.imageView.center = destination;
                         }
                         completion:^(BOOL finished) {
                             [self animateTranslation];
                         }];
    }
}

# pragma mark - Orientation

- (UIInterfaceOrientationMask)  supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

# pragma mark - Actions

- (IBAction)actionRotation:(UISwitch *)sender {
    [self actionSwitchType:DZChoosenParameterRotation sender:sender];
    [self animateRotation];
}

- (IBAction)actionScale:(UISwitch *)sender {
    [self actionSwitchType:DZChoosenParameterScale sender:sender];
}

- (IBAction)actionTranslation:(UISwitch *)sender {
    [self actionSwitchType:DZChoosenParameterTranslation sender:sender];
    [self animateTranslation];
}

- (IBAction)actionParameter:(UISlider *)sender {
    [self setValue:sender.value byParameter:self.choosenParameter];
}

- (IBAction)actionTypeSegments:(UISegmentedControl *)sender {
    [self setImageToImageView];
}

# pragma mark - Randoms

- (CGFloat)randomCGFloatFrom:(CGFloat) startNumber to:(CGFloat) endNumber {
    return startNumber + (CGFloat)(arc4random_uniform((endNumber - startNumber) * 10001)) / 10000;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
