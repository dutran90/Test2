//
//  MainViewController.m
//  Test2
//
//  Created by Alex Tran on 8/26/15.
//  Copyright (c) 2015 Alex Tran. All rights reserved.
//

#import "MainViewController.h"
#import "DayRate.h"
#import "DayRateCell.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIAlertView+Blocks.h"
#import "ChartViewController.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *dayRateTableView;
@property (strong, nonatomic) NSMutableArray *dayRateObjects;
@property (nonatomic) BOOL isCurrentDate;
@property (strong, nonatomic) MBProgressHUD *hud;;
@property (strong, nonatomic) NSMutableArray *filterDayRateObjects;
@property (nonatomic) BOOL isFilter;
- (IBAction)changeValueSegment:(id)sender;


@end

@implementation MainViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _filterDayRateObjects = [NSMutableArray new];
     _dayRateObjects = [NSMutableArray new];
    [self loadDataCurrentDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load Data
- (void)loadDataCurrentDate{
    //Default Value
    _isFilter = NO;
    _isCurrentDate = YES;
    
    //Load data of type is current date
    [self showProgress];
    [DayRate getDayRateWithUsername:_username andPassword:_password inBackground:^(DayRate *dayRateObject, BOOL success, NSError *error) {
        [self hideProgress];
        if (!error) {
            if (success) {
                [_dayRateObjects addObject: dayRateObject];
                [_dayRateTableView reloadData];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Username or password is not correct" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (void)loadData90Days{
    //Default Value
    _isFilter = NO;
    _isCurrentDate = NO;

    //Load data of type is the last 90 days
    [self showProgress];
    [DayRate getDayRate90WithUsername:_username andPassword:_password inBackground:^(NSMutableArray *dayRateObjects, BOOL success, NSError *error) {
        [self hideProgress];
        if (!error) {
            if (success) {
                _dayRateObjects = dayRateObjects;
                [_dayRateTableView reloadData];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Username or password is not correct" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (_isFilter) {
        return _filterDayRateObjects.count;
    }else{
        return _dayRateObjects.count;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (_isFilter) {
        DayRate *dayRateObject = _filterDayRateObjects[section];
        return dayRateObject.rates.count;
    }else{
        DayRate *dayRateObject = _dayRateObjects[section];
        return dayRateObject.rates.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DayRateCell";
    
    DayRateCell *dayRateCell = (DayRateCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (dayRateCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DayRateCell" owner:self options:nil];
        dayRateCell = (DayRateCell *)[nib objectAtIndex:0];
    }
    
    DayRate *dayRateObject;
    if (_isFilter) {
        dayRateObject = _filterDayRateObjects[indexPath.section];
    }else{
        dayRateObject = _dayRateObjects[indexPath.section];
    }
    if (dayRateObject) {
        NSDictionary *rateDictionary = [dayRateObject.rates objectAtIndex:indexPath.row];
        dayRateCell.currencyLabel.text = [NSString stringWithFormat:@"%@", [rateDictionary objectForKey:@"Id"]];
        dayRateCell.rateLabel.text = [NSString stringWithFormat:@"%0.4f", [[rateDictionary objectForKey:@"Rate"] floatValue]];
    }
    
    return dayRateCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    DayRate *dayRateObject;
    if (_isFilter) {
        dayRateObject = _filterDayRateObjects[section];
    }else{
        dayRateObject = _dayRateObjects[section];
    }
    sectionName = dayRateObject.day;
    return sectionName;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DayRateCell *cell = (DayRateCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Row pressed!!");
    if (!_isCurrentDate) {
        ChartViewController *chartViewController = [[ChartViewController alloc] initWithNibName:@"ChartViewController"bundle:nil];
        if (_isFilter) {
            // Create array Days
            NSMutableArray *days = [NSMutableArray new];
            NSMutableArray *currencyRates = [NSMutableArray new];
            for (int i = 0; i < _filterDayRateObjects.count; i++) {
                DayRate *dayRateObject = _filterDayRateObjects[i];
                [days addObject:dayRateObject.day];
                for (int j = 0; j < dayRateObject.rates.count; j++) {
                    NSDictionary *rateDictionary = dayRateObject.rates[j];
                    if ([[rateDictionary objectForKey:@"Id"] isEqualToString: cell.currencyLabel.text]) {
                        [currencyRates addObject:[NSNumber numberWithFloat:[[rateDictionary objectForKey:@"Rate"] floatValue]]];
                        break;
                    }
                }
            }
            chartViewController.days = days;
            chartViewController.currencyRates = currencyRates;
        }else{
            // Create array Days
            NSMutableArray *days = [NSMutableArray new];
            NSMutableArray *currencyRates = [NSMutableArray new];
            for (int i = 0; i < _dayRateObjects.count; i++) {
                DayRate *dayRateObject = _dayRateObjects[i];
                //show first day and end day
                if (i ==  0 || i ==_dayRateObjects.count - 1) {
                    [days addObject:dayRateObject.day];
                }else{
                    [days addObject:@""];
                }
                for (int j = 0; j < dayRateObject.rates.count; j++) {
                    NSDictionary *rateDictionary = dayRateObject.rates[j];
                    if ([[rateDictionary objectForKey:@"Id"] isEqualToString: cell.currencyLabel.text]) {
                        [currencyRates addObject:[NSNumber numberWithFloat:[[rateDictionary objectForKey:@"Rate"] floatValue]]];
                        break;
                    }
                }
            }
            chartViewController.days = days;
            chartViewController.currencyRates = currencyRates;
        }
        [self.navigationController pushViewController:chartViewController animated:YES];
    }
}

#pragma mark - UISearchDisplayController Delegate Methods

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    tableView.backgroundColor = [UIColor whiteColor];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    _filterDayRateObjects = nil;
    _isFilter = NO;
    [_dayRateTableView reloadData];
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [_filterDayRateObjects removeAllObjects];
    _filterDayRateObjects = [NSMutableArray new];
    BOOL hasAddToFilter = NO;
    
    _isFilter = YES;
    for (int i = 0; i < _dayRateObjects.count; i++) {
        DayRate *dayRateObject = _dayRateObjects[i];
        DayRate *dayRateObjectNew = [DayRate new];
        dayRateObjectNew.day = dayRateObject.day;
        NSMutableArray *ratesNew = [NSMutableArray new];
        for (int j = 0; j < dayRateObject.rates.count; j++) {
            NSDictionary *rateDictionary = dayRateObject.rates[j];
            if ([[rateDictionary objectForKey:@"Id"] rangeOfString:searchText].location != NSNotFound) {
                [ratesNew addObject:rateDictionary];
                dayRateObjectNew.rates = ratesNew;
                hasAddToFilter = YES;
            }
        }
        if (hasAddToFilter) {
            [_filterDayRateObjects addObject:dayRateObjectNew];
        }
    }
}

#pragma mark - MBProgressHud function
- (void)showProgress{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"loading...";
    [_hud show:YES];
}

- (void)hideProgress{
    [_hud hide:YES];
}

#pragma mark - Touch Action
- (IBAction)changeValueSegment:(id)sender {
    if (_segmentedControl.selectedSegmentIndex == 0) {
        [self loadDataCurrentDate];
    }else{
        [self loadData90Days];
    }
}
@end
