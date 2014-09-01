//
//  Thumbnailpicker.h
//  thumbnailpicker
//
//  Created by Vijay Kumar on 6/24/14.
//  Copyright (c) 2014 Scroll. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThumbnailPickerView;

@protocol ThumbnailPickerViewDelegate <NSObject>
@optional
- (void)thumbnailPickerView:(ThumbnailPickerView *)thumbnailPickerView didSelectImageWithIndex:(NSUInteger)index;
@end


@protocol ThumbnailPickerViewDataSource <NSObject>
- (NSUInteger)numberOfImagesForThumbnailPickerView:(ThumbnailPickerView *)thumbnailPickerView;
- (UIImage *)thumbnailPickerView:(ThumbnailPickerView *)thumbnailPickerView imageAtIndex:(NSUInteger)index;
@end


@interface ThumbnailPickerView : UIControl

- (void)reloadData;
- (void)reloadThumbnailAtIndex:(NSUInteger)index;

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;

// NSNotFound if nothing is selected
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, weak) IBOutlet id<ThumbnailPickerViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<ThumbnailPickerViewDelegate> delegate;
@end
