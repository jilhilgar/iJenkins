//
//  FTAccountOverviewCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 03/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAccountOverviewCell.h"


@interface FTAccountOverviewCell ()

@property (nonatomic, strong) XYPieChart *chart;
@property (nonatomic, assign) NSUInteger sliceAnimationCount;

@end


@implementation FTAccountOverviewCell


#pragma mark Creating elements

- (void)createPieChart {
    _chart = [[XYPieChart alloc] initWithFrame:CGRectMake(2, 10, 180, 180)];
    [_chart setDataSource:self];
    [_chart setDelegate:self];
    [_chart setStartPieAngle:DegreesToRadians(-90)];
    [_chart setAnimationSpeed:0.8];
    [_chart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [_chart setPieCenter:CGPointMake((_chart.width / 2), (_chart.width / 2))];
    [_chart setLabelShadowColor:[UIColor clearColor]];
    [_chart setSelectedSliceOffsetRadius:4];
    [_chart setBackgroundColor:[UIColor clearColor]];
    [_chart setLabelRadius:3];
    [self addSubview:_chart];
    
    UIView *center = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [center.layer setCornerRadius:(center.width / 2)];
    [center setBackgroundColor:[UIColor whiteColor]];
    [center setCenter:_chart.center];
    [self addSubview:center];
    
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:_chart selector:@selector(reloadData) userInfo:nil repeats:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(startInitialChartSliceAnimation) userInfo:nil repeats:NO];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self createPieChart];
}

#pragma mark Animation

- (void)startInitialChartSliceAnimation {
    _sliceAnimationCount = 0;
    NSTimer *chartAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(initialChartSliceAnimation:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:chartAnimationTimer forMode:NSRunLoopCommonModes];
}

- (void)deselectSliceWithTimer:(NSTimer *)timer {
    [_chart setSliceDeselectedAtIndex:[[timer userInfo] integerValue]];
}

- (void)initialChartSliceAnimation:(NSTimer *)timer {
    if (_sliceAnimationCount < 7) {
        [self pieChart:_chart didSelectSliceAtIndex:_sliceAnimationCount];
        [_chart setSliceSelectedAtIndex:_sliceAnimationCount];
        NSNumber *sliceNumber = [NSNumber numberWithInteger:_sliceAnimationCount];
        [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(deselectSliceWithTimer:) userInfo:sliceNumber repeats:NO];
        _sliceAnimationCount++;
    }
    else {
        [timer invalidate];
        timer = nil;
        self.userInteractionEnabled = YES;
        [self handleDelayedDeselection];
    }
}

#pragma mark Pie chart delegate & datasource methods

- (UIColor *)colorForItemAtIndex:(NSInteger)index {
    NSString *key = [_jobsStats.allKeys objectAtIndex:index];
    FTAPIJobsStatsDataObject *s = [_jobsStats objectForKey:key];
    
    UIColor *sliceColor;
    
    if ([s.color isEqualToString:@"red"]) {
        sliceColor = [UIColor colorWithHexString:@"FF4000"];
    }
    else if ([s.color isEqualToString:@"blue"]) {
        sliceColor = [UIColor colorWithHexString:@"0076FF"];
    }
    else if ([s.color isEqualToString:@"yellow"]) {
        sliceColor = [UIColor colorWithHexString:@"FFDC73"];
    }
    else if ([s.color isEqualToString:@"aborted"]) {
        sliceColor = [UIColor grayColor];
    }
    else if ([s.color isEqualToString:@"disabled"]) {
        sliceColor = [UIColor darkGrayColor];
    }
    else if ([s.color isEqualToString:@"notbuilt"]) {
        sliceColor = [UIColor lightGrayColor];
    }
    else  {
        sliceColor = [UIColor colorWithHexString:@"FF99FF"];
    }
    return sliceColor;
}

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return _jobsStats.allKeys.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    NSString *key = [_jobsStats.allKeys objectAtIndex:index];
    FTAPIJobsStatsDataObject *s = [_jobsStats objectForKey:key];
    return s.count;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    return [self colorForItemAtIndex:index];
}

- (void)pieChart:(XYPieChart *)pieChart didSelectSlice:(SliceLayer *)sliceLayer withIndex:(NSInteger)index {
    if ([_delegate respondsToSelector:@selector(accountOverviewCell:requiresFilterForStat:)]) {
        NSString *key = [_jobsStats.allKeys objectAtIndex:index];
        FTAPIJobsStatsDataObject *s = [_jobsStats objectForKey:key];
        [_delegate accountOverviewCell:self requiresFilterForStat:s];
    }
    
    
//    [_chartOverlay setStartAngle:sliceLayer.startAngle];
//    [_chartOverlay setEndAngle:sliceLayer.endAngle];
//    [_chartOverlay setSliceColor:[UIColor colorWithHexString:[self colorForItemAtIndex:index]]];
//    [_chartOverlay setNeedsDisplay];
//    [UIView animateWithDuration:0.15 animations:^{
//        [_chartOverlay setAlpha:1];
//    }];
}

- (void)handleDelayedDeselection {
    [_chart deselectCurrenSlice];
}

- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index {
//    if (index >= 7) return;
//    [_priceLabel setText:[self priceForItemAtIndex:index]];
//    [_dateLabel setText:[[self titleForItemAtIndex:index] uppercaseString]];
//    [_priceLabel sizeToFit];
//    [_priceLabel centerHorizontally];
//    _priceLabel.center = CGPointMake(_chartContentView.frame.size.width / 2, _priceLabel.center.y);
//    [_currencyTagLabel setXOrigin:(_priceLabel.right + 4)];
//    
//    CGAffineTransform t = CGAffineTransformMakeScale(1.02, 1.02);
//    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        [_chartCenter setTransform:t];
//        if (!_autoAnimating)
//            [_chartContentView setTransform:t];
//    } completion:^(BOOL finished) {
//        CGAffineTransform t2 = CGAffineTransformMakeScale(1.0, 1.0);
//        [UIView animateWithDuration:0.15 animations:^{
//            if (!_autoAnimating)
//                [_chartContentView setTransform:t2];
//        }];
//    }];
//    
//    if (index > 6) return;
//    if (!_autoAnimating && _scrolled) {
//        RGSummaryCellView *v = [_scrollElements objectAtIndex:(index + 1)];
//        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            [v.colorIndicator setWidth:20];
//            [v.titleLabel setXOrigin:40];
//            [v.priceLabel setXOrigin:40];
//            [v.currencyTagLabel setXOrigin:(v.priceLabel.right + 2)];
//        } completion:^(BOOL finished) {
//            [v.accessoryArrow setImage:[UIImage imageNamed:@"RG_mb_arrow_icon_OFF"]];
//        }];
//    }
//    
//    if (!self.scrollEnabled) {
//        
//        [self startDeselectTimerWithInterval:2];
//    }
}

- (void)startDeselectTimerWithInterval:(NSTimeInterval)interval {
//    if (_deselectTimer) {
//        [_deselectTimer invalidate];
//        _deselectTimer = nil;
//    }
//    _deselectTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(handleDelayedDeselection) userInfo:nil repeats:NO];
//    [[NSRunLoop mainRunLoop] addTimer:_deselectTimer forMode:NSRunLoopCommonModes];
}

- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index {
//    CGAffineTransform t = CGAffineTransformMakeScale(1.0, 1.0);
//    [self showTotalPrice];
//    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        [_chartCenter setTransform:t];
//        [_chartOverlay setAlpha:0];
//    } completion:^(BOOL finished) {
//        
//    }];
//    
//    if (index > 6) return;
//    RGSummaryCellView *v = [_scrollElements objectAtIndex:(index + 1)];
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        [v.colorIndicator setWidth:10];
//        [v.titleLabel setXOrigin:30];
//        [v.priceLabel setXOrigin:30];
//        [v.currencyTagLabel setXOrigin:(v.priceLabel.right + 2)];
//    } completion:^(BOOL finished) {
//        [v.accessoryArrow setImage:[UIImage imageNamed:@"RG_mb_arrow_icon_OFF"]];
//    }];
}


@end