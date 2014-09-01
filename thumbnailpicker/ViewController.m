//
//  ViewController.m
//  thumbnailpicker
//
//  Created by Vijay Kumar on 6/24/14.
//  Copyright (c) 2014 Scroll. All rights reserved.
//

#import "ViewController.h"
#import "ThumbnailPicker.h"


@interface ViewController() <ThumbnailPickerViewDataSource, ThumbnailPickerViewDelegate>

- (IBAction)_reloadThumbnailPickerView;
- (IBAction)_sliderValueChanged:(UISlider *)sender;
- (void)_updateUIWithSelectedIndex:(NSUInteger)index;

@property (weak, nonatomic) IBOutlet UISlider *numberOfItemsSlider;
@property (weak, nonatomic) IBOutlet UISlider *selectedIndexSlider;
@property (weak, nonatomic) IBOutlet UILabel *numberOfItemsLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedIndexLabel;
@property (weak, nonatomic) IBOutlet UILabel *reloadTimeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet ThumbnailPickerView *thumbnailPickerView;
@end


@implementation ViewController

@synthesize images = _images;
@synthesize imageView = _imageView, infoLabel = _infoLabel;
@synthesize numberOfItemsSlider = _numberOfItemsSlider, selectedIndexSlider = _selectedIndexSlider,
numberOfItemsLabel = _numberOfItemsLabel, selectedIndexLabel = _selectedIndexLabel,
reloadTimeLabel = _reloadTimeLabel;
@synthesize toolbar = _toolbar, thumbnailPickerView = _thumbnailPickerView;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    _numberOfItems = self.images.count;
    
    self.numberOfItemsSlider.minimumValue = 0;
    self.numberOfItemsSlider.maximumValue = _numberOfItems;
    self.numberOfItemsSlider.value = _numberOfItems;
    self.numberOfItemsLabel.text = [NSString stringWithFormat:@"%d", _numberOfItems];
    
    self.selectedIndexSlider.minimumValue = 0;
    self.selectedIndexSlider.maximumValue = _numberOfItems-1;
    self.selectedIndexLabel.text = [NSString string];
    
    self.reloadTimeLabel.text = [NSString string];
    self.infoLabel.text = [NSString string];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Private API

- (void)_reloadThumbnailPickerView
{
    NSDate *date1 = [NSDate date];
    [self.thumbnailPickerView reloadData];
    NSDate *date2 = [NSDate date];
    self.reloadTimeLabel.text = [NSString stringWithFormat:@"reloaded in %.4fs", [date2 timeIntervalSinceDate:date1]];
}

- (void)_sliderValueChanged:(UISlider *)sender
{
    NSInteger value = [sender value];
    if (sender == self.selectedIndexSlider) {
        [self.thumbnailPickerView setSelectedIndex:value animated:YES];
        [self _updateUIWithSelectedIndex:value];
    } else if (sender == self.numberOfItemsSlider) {
        if (_numberOfItems != value) {
            _numberOfItems = value;
            self.selectedIndexSlider.maximumValue = _numberOfItems == 0 ? 0 : _numberOfItems-1;
            self.numberOfItemsLabel.text = [NSString stringWithFormat:@"%d", _numberOfItems];
            [self _reloadThumbnailPickerView];
            self.infoLabel.text = [NSString stringWithFormat:@"%d of %d", (int)self.selectedIndexSlider.value+1, _numberOfItems];
            
            if (_numberOfItems <= self.thumbnailPickerView.selectedIndex) {
                [self.thumbnailPickerView setSelectedIndex:self.selectedIndexSlider.maximumValue animated:YES];
                [self _updateUIWithSelectedIndex:self.selectedIndexSlider.maximumValue];
            }
        }
    }
}

- (void)_updateUIWithSelectedIndex:(NSUInteger)index
{
    self.imageView.image = [self.images objectAtIndex:index];
    self.infoLabel.text = [NSString stringWithFormat:@"%d of %d", index+1, _numberOfItems];
    self.selectedIndexSlider.value = index;
    self.selectedIndexLabel.text = [NSString stringWithFormat:@"%d", index];
}

#pragma mark - ThumbnailPickerView data source

- (NSUInteger)numberOfImagesForThumbnailPickerView:(ThumbnailPickerView *)thumbnailPickerView
{
    return _numberOfItems;
}

- (UIImage *)thumbnailPickerView:(ThumbnailPickerView *)thumbnailPickerView imageAtIndex:(NSUInteger)index
{
    UIImage *image = [self.images objectAtIndex:index];
    usleep(10*1000);
    return image;
}

#pragma mark - ThumbnailPickerView delegate

- (void)thumbnailPickerView:(ThumbnailPickerView *)thumbnailPickerView didSelectImageWithIndex:(NSUInteger)index
{
    [self _updateUIWithSelectedIndex:index];
}

@end
