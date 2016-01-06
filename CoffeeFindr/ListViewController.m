//
//  ListViewController.m
//  CoffeeFindr
//
//  Created by Jerry on 1/4/16.
//  Copyright © 2016 Jerry Lao. All rights reserved.
//

#import "ListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CoffeePlace.h"
#import "DetailViewController.h"

@interface ListViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property NSArray *coffeePlacesArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self updateCurrentLocation];
}

- (void)updateCurrentLocation {
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)findCoffeePlaces:(CLLocation *)location {
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"coffee";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(.05, .05));
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        NSArray *mapItems = [response mapItems];
        NSMutableArray *tempArray = [NSMutableArray new];
        for(int i=0; i<mapItems.count; i++){
            MKMapItem *mapItem = [mapItems objectAtIndex:i];
            CLLocationDistance metersAway = [mapItem.placemark.location distanceFromLocation:location];
            float milesDifference = metersAway / 1609.34;
            
            CoffeePlace *coffeePlace = [CoffeePlace new];
            coffeePlace.mapItem = mapItem;
            coffeePlace.milesDifference = milesDifference;
            
            [tempArray addObject:coffeePlace];
        }
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"milesDifference" ascending:true];
        NSArray *sortedArray = [tempArray sortedArrayUsingDescriptors:@[sortDescriptor]];
        self.coffeePlacesArray = [NSArray arrayWithArray:sortedArray];
        [self.tableView reloadData];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.currentLocation = locations.firstObject;
    [self.locationManager stopUpdatingLocation];
    [self findCoffeePlaces:self.currentLocation];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.coffeePlacesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [[[self.coffeePlacesArray objectAtIndex:indexPath.row] mapItem] name];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1f miles away",[[self.coffeePlacesArray objectAtIndex:indexPath.row] milesDifference]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1f miles away", [self.coffeePlacesArray[indexPath.row] milesDifference]];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *detailVC = [segue destinationViewController];
    detailVC.coffeePlace = [self.coffeePlacesArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    detailVC.currentLocation = self.currentLocation;
}

@end
