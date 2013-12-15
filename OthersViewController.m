
#import "OthersViewController.h"
#import "OthersCell.h"

@interface OthersViewController ()

@end

@implementation OthersViewController
@synthesize collectionOthers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    filenames = [[NSMutableArray alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *location=@"Others";
    NSString *fPath = [documentsDirectory stringByAppendingPathComponent:location];
    NSArray *directoryContent = [[NSFileManager defaultManager] directoryContentsAtPath: fPath];
    collectionOthers.delegate =self;
    collectionOthers.dataSource=self;
    for(NSString *str in directoryContent)
    {
        NSString *finalFilePath = [fPath stringByAppendingPathComponent:str];
        [filenames addObject:finalFilePath];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSLog(@"j");
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [filenames count];
    NSLog(@"a");

    
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ReuseID";
    OthersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    UIImageView *imageInCell = (UIImageView*)[cell viewWithTag:1];
    
    NSString *cacheKey = filenames[indexPath.item];
    imageInCell.image = [self.imageCache objectForKey:cacheKey];
    
    if (imageInCell.image == nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:filenames[indexPath.item]];
            if (image) {
                [self.imageCache setObject:image forKey:cacheKey];
                dispatch_async(dispatch_get_main_queue(), ^{
                    OthersCell *updateCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
                    UIImageView *imageInCell = (UIImageView*)[updateCell viewWithTag:1];
                    imageInCell.image = image;
                });
            }
        });
    }
    NSLog(@"a");
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self.imageCache removeAllObjects];
}

@end
