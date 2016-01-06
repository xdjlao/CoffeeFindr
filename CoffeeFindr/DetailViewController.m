//
//  DetailViewController.m
//  CoffeeFindr
//
//  Created by Jerry on 1/5/16.
//  Copyright © 2016 Jerry Lao. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [[self.coffeePlace mapItem] name];
    [self getPathDirections:self.currentLocation.coordinate withDestination:self.coffeePlace.mapItem.placemark.location.coordinate];
}

- (void)getPathDirections:(CLLocationCoordinate2D)source withDestination:(CLLocationCoordinate2D)destination {
    MKPlacemark *placemarkSrc = [[MKPlacemark alloc] initWithCoordinate:source addressDictionary:nil];
    MKMapItem *mapItemSrc = [[MKMapItem alloc] initWithPlacemark:placemarkSrc];
    
    MKPlacemark *placemarkDest = [[MKPlacemark alloc] initWithCoordinate:destination addressDictionary:nil];
    MKMapItem *mapItemDest = [[MKMapItem alloc] initWithPlacemark:placemarkDest];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:mapItemSrc];
    [request setDestination:mapItemDest];
    [request setTransportType:MKDirectionsTransportTypeWalking];
    [request setRequestsAlternateRoutes:NO];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        MKRoute *route = response.routes.lastObject;
        
        NSString *completeDirections = [NSString new];
        int count = 1;
        
        for (MKRouteStep *step in route.steps) {
            NSString *stepInstructions = [NSString stringWithFormat:@"%i. %@", count, [step instructions]];
            completeDirections = [completeDirections stringByAppendingString: stepInstructions];
            completeDirections = [completeDirections stringByAppendingString: @"\n\n"];
            self.textView.text = completeDirections;
            count++;
        }
    }];
}

@end
