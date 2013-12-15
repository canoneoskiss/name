//
//  iCarouselExampleViewController.h
//  Couturier
//
//  Created by Kento on 2013/08/26.
//  Copyright (c) 2013年 Kento. All rights reserved.
//

#import "iCarouselExampleViewController.h"


@interface iCarouselExampleViewController ()

@property (nonatomic, retain) NSMutableArray *items1;
@property (nonatomic, retain) NSMutableArray *items2;

@end


@implementation iCarouselExampleViewController

@synthesize carousel1;
@synthesize carousel2;
@synthesize items1;
@synthesize items2;

- (void)awakeFromNib
{
    NSLog(@"ooooo");
    //set up data sources
    self.items1 = [NSMutableArray array];
    for (int i = 0; i < 100; i++)
    {
        [items1 addObject:[NSNumber numberWithInt:i]];
    }
    
    self.items2 = [NSMutableArray array];
    for (int i = 65; i < 65 + 58; i++)
    {
        [items2 addObject:[NSString stringWithFormat:@"%c", i]];
    }
}

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    carousel1.delegate = nil;
    carousel1.dataSource = nil;
    carousel2.delegate = nil;
    carousel2.dataSource = nil;
    
}

#pragma mark -
#pragma mark View lifecycle

-(void)viewDidLoad
{
    NSLog(@"a");
    [super viewDidLoad];    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager  = [NSFileManager defaultManager];
    
    //configure carousel1
    NSString *fPath = [documentsDirectory stringByAppendingPathComponent:@"Tops"];
    NSArray *directoryContent = [fileManager directoryContentsAtPath: fPath];
    imageArray1 = [directoryContent mutableCopy];
    if ([imageArray1 count] > 0) {
        NSLog(@"%@", [imageArray1 objectAtIndex:0]); //This line is 70
        NSLog(@"1:::%d", [imageArray1 count]);
    } else {
        NSLog(@"No objects in imageArray1.");
    }
    
    //configure carousel2
    fPath = [documentsDirectory stringByAppendingPathComponent:@"Bottoms"];
    directoryContent = [fileManager directoryContentsAtPath: fPath];
    imageArray2 = [directoryContent mutableCopy];
    if ([imageArray2 count] > 0) {
        NSLog(@"%@", [imageArray2 objectAtIndex:0]); //This line is 70
        NSLog(@"1:::%d", [imageArray1 count]);
    } else {
        NSLog(@"No objects in imageArray2.");
    }
    
    carousel1.type = iCarouselTypeLinear;
    carousel2.type = iCarouselTypeLinear;
    
    [carousel1 reloadData];
    [carousel2 reloadData];
    
    carousel1.delegate = self;
    carousel1.dataSource = self;
    carousel2.delegate = self;
    carousel2.dataSource = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //free up memory by releasing subviews
    self.carousel1 = nil;
    self.carousel2 = nil;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    NSLog(@"n");
    //return the total number of items in the carousel
    if (carousel == carousel1)
    {
        NSLog(@"n1:%d", [imageArray1 count]);
        return [imageArray1 count];
    }
    else
    {
        NSLog(@"n2:%d", [imageArray2 count]);
        return [imageArray2 count];
    }
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    NSLog(@"aaaaa%d", index);
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
    }
    UIImage *image;
    if (carousel == carousel1)
    {
        NSLog(@"111111");
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fPath = [documentsDirectory stringByAppendingPathComponent:@"Tops"];
        image  = [UIImage imageWithContentsOfFile: [fPath stringByAppendingPathComponent:[imageArray1 objectAtIndex:index]]];
        ((UIImageView *)view).image = image;
    }
    else
    {
        NSLog(@"22222222");
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fPath = [documentsDirectory stringByAppendingPathComponent:@"Bottoms"];
        image  = [UIImage imageWithContentsOfFile: [fPath stringByAppendingPathComponent:[imageArray2 objectAtIndex:index]]];            ((UIImageView *)view).image = image;
        
    }
    return view;
    
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //NSLog(@"C");
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionSpacing:
        {
            if (carousel == carousel2)
            {
                //add a bit of spacing between the item views
                return value * 1.05f;
            }
        }
        default:
        {
            return value;
        }
    }
}

@end
