//
//  ViewController.m
//  Calculator
//
//  Created by Christopher Legg on 1/30/15.
//  Copyright (c) 2015 ucdenver. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorBrain.h"

@interface ViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation ViewController

@synthesize display;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    NSRange range = [self.display.text rangeOfString:@"."];
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        //allows entry after one period
        if ((![digit isEqual: @"."]) && (range.location != NSNotFound)) {
            self.display.text = [self.display.text stringByAppendingString:digit];
        }
        //allows one period
        else if ([digit isEqual: @"."] && (range.location == NSNotFound)) {
            self.display.text = [self.display.text stringByAppendingString:digit];
        }
        //append digits
        else if (![digit isEqual: @"."] && (range.location == NSNotFound)) {
            self.display.text = [self.display.text stringByAppendingString:digit];
        }
    }
    else {
        if ([digit isEqual:@"0"]) {
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
        else {
            self.display.text = digit;
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
    }
}

- (IBAction)enterPressed
{
    NSInteger length = self.display2.text.length;
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        //clears display2 after 20 characters
        if (length > 20) {
            self.display2.text = @"";
        }
        //display appended to display2
        self.display2.text = [self.display2.text stringByAppendingString:self.display.text];
        [self.brain pushOperand:[self.display.text doubleValue]];
    
        self.display2.text = [self.display2.text stringByAppendingString:@" "];
        self.display.text = @"0";
    }
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(id)sender
{
    NSString *operation = [sender currentTitle];
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display2.text = [self.display2.text stringByAppendingString:operation];
        self.display2.text = [self.display2.text stringByAppendingString:@" "];
        [self enterPressed];
    }

    double result = [self.brain performOperation:operation];
    
    self.display2.text = [self.display2.text stringByAppendingString:@" = "];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.display2.text = [self.display2.text stringByAppendingString:self.display.text];
    self.display2.text = [self.display2.text stringByAppendingString:@" | "];
}

- (IBAction)clearPressed {
    [self.brain clear];
    self.display.text = @"0";
    self.display2.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)backspacePressed
{
    if (!userIsInTheMiddleOfEnteringANumber)
       return;
    
    NSInteger length = self.display.text.length;

    if (length > 1) {
        self.display.text = [self.display.text substringToIndex: length-1 ];
    }
    else {
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
}

- (IBAction)plusOrMinusPressed:(UIButton *)sender
{
    NSRange range = [self.display.text rangeOfString:@"-"];
    NSString *list = self.display.text;
    
    if (range.location == NSNotFound) {
        self.display.text= @"";
        self.display.text = [self.display.text stringByAppendingString:@"-"];
        self.display.text = [self.display.text stringByAppendingString:list];
    }
    else {
        self.display.text = [self.display.text substringFromIndex:1];
    }
}

@end
