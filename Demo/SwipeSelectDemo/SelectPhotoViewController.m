//
//  SelectPhotoViewController.m
//  SwipeSelectDemo
//
//  Created by Ray Tsaihong and Andrew Ng on 8/5/13.
//  Copyright (c) 2013 Ray Tsaihong and Andrew Ng. All rights reserved.
//

#import "SelectPhotoViewController.h"
#import "PhotoCell.h"
#import "ARSwipeToSelectGestureRecognizer.h"

@interface SelectPhotoViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *assets;
@end

@implementation SelectPhotoViewController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    self.collectionView.allowsSelection = self.collectionView.allowsMultipleSelection = YES;
    self.assets = [[NSMutableArray alloc] initWithCapacity:[self.group numberOfAssets]];
    [self loadAssets];
	// Do any additional setup after loading the view.
    ARSwipeToSelectGestureRecognizer *gestureRecognizer = [[ARSwipeToSelectGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:) toggleSelectedHandler:^(NSIndexPath *indexPath) {
        if ([[self.collectionView indexPathsForSelectedItems] containsObject:indexPath]) {
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
            [self.collectionView cellForItemAtIndexPath:indexPath].alpha = 1.0;
        } else {
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [self.collectionView cellForItemAtIndexPath:indexPath].alpha = 0.5;
        }
        [self checkButton];
    }];

    [self.collectionView addGestureRecognizer:gestureRecognizer];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showShareController:)];

    button.enabled = NO;
    self.navigationItem.rightBarButtonItem = button;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.assets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    ALAsset * asset = (ALAsset *)self.assets[indexPath.row];
    cell.imageView.image = [UIImage imageWithCGImage:asset.thumbnail];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Private methods
- (IBAction)handleGesture:(id)sender {
    // Do nothing
}

- (void)loadAssets
{
    self.assets = [[NSMutableArray alloc] initWithCapacity:[self.group numberOfAssets]];
    [self.group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [self.assets addObject:result];
        }
    }];
}

- (void)showShareController:(id)sender
{
    NSArray *selectedIndexPaths = [self.collectionView indexPathsForSelectedItems];
    NSMutableArray *returnAssets = [[NSMutableArray alloc] initWithCapacity:selectedIndexPaths.count];
    [selectedIndexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = (NSIndexPath *)obj;
        [returnAssets addObject:self.assets[indexPath.row]];
    }];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:returnAssets applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)checkButton
{
    self.navigationItem.rightBarButtonItem.enabled = ([self.collectionView indexPathsForSelectedItems].count > 0);
}

@end
