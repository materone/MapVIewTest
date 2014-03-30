//
//  RouteDataViewer.m
//  MapVIewTest
//
//  Created by tony on 14-2-28.
//  Copyright (c) 2014年 tony. All rights reserved.
//

#import "RouteDataViewer.h"

@interface RouteDataViewer ()

@end


@implementation RouteDataViewer

@synthesize data;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //disable data button
    //NSString* filePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"csv"];
    //[self loadRouteData:filePath];
    
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    DocDir = [documentDirectories objectAtIndex:0];
    fm = [NSFileManager defaultManager];
    NSError *error = nil;
    
    files = [NSMutableArray arrayWithArray:[fm contentsOfDirectoryAtPath:DocDir  error:&error]];
    if (files == nil) {
        // Handle the error
        NSLog(@"Get Directory files error!!");
    }
    
    NSLog(@"Files %d",[files count]);
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)loadRouteData:(NSString *)filePath{
    NSString* fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray* pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableArray *routesLatM = [[NSMutableArray alloc]init];
    NSMutableArray *routesLongM = [[NSMutableArray alloc]init];
    
    for(int idx = 0; idx < pointStrings.count; idx++)
    {
        // break the string down even further to latitude and longitude fields.
        NSString* currentPointString = [pointStrings objectAtIndex:idx];
        NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        
        [routesLatM addObject:[latLonArr objectAtIndex:0] ];
        [routesLongM addObject:[latLonArr objectAtIndex:1] ];
        
    }
    
    routesLong = routesLongM;
    routesLat = routesLatM;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [routesLat count];
    return [files count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    //cell.textLabel.text = [ NSString stringWithFormat:@"%f",[[routesLat objectAtIndex:indexPath.row]doubleValue]] ;
    cell.textLabel.text = [files objectAtIndex:indexPath.row];
    fileAttr = [fm attributesOfItemAtPath:[DocDir stringByAppendingPathComponent:[files objectAtIndex:indexPath.row]] error:nil];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[fileAttr valueForKey:NSFileSize]];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Delete the file
        NSError *err=nil;
        [fm removeItemAtPath:[DocDir stringByAppendingPathComponent:[files objectAtIndex:indexPath.row]] error:&err];
        [files removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation


// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    RouteViewController *dest = [segue destinationViewController];
    // Pass the selected object to the new view controller.
    if([sender isKindOfClass:[UITableViewCell class]]){
        NSLog(@"UITableViewCell ohh!");
        UITableViewCell *cell = sender;
        [dest setFilePath:[DocDir stringByAppendingPathComponent:cell.textLabel.text]];
        [dest caculateRoute:dest.filePath isArray:YES];
        AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        appDel.bShowmap = YES;
        //[dest displayRoute];
    }
}

- (IBAction)doBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
    [self.navigationController navigationItem];
}
@end
