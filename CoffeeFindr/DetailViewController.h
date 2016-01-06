//
//  DetailViewController.h
//  CoffeeFindr
//
//  Created by Jerry on 1/5/16.
//  Copyright © 2016 Jerry Lao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoffeePlace.h"

@interface DetailViewController : UIViewController

@property CoffeePlace *coffeePlace;
@property CLLocation *currentLocation;

@end
