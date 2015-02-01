//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Link on 1/30/15.
//  Copyright (c) 2015 ucdenver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand: (double)operand;
- (double)performOperation:(NSString *)operation;

@end
