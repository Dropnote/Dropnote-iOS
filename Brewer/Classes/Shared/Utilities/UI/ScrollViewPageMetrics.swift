//
// Created by Maciej Oczko on 31.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

protocol ScrollViewPageMetricsType {
    func isFirstPage(of scrollView: UIScrollView) -> Bool
    func isLastPage(of scrollView: UIScrollView) -> Bool
    func currentPageIndex(for scrollView: UIScrollView) -> Int
}

final class ScrollViewPageMetrics: ScrollViewPageMetricsType {

    func isFirstPage(of scrollView: UIScrollView) -> Bool {
        return scrollView.contentOffset.x < scrollView.frame.size.width
    }
    
    func isLastPage(of scrollView: UIScrollView) -> Bool {
        return scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width)
    }

    func currentPageIndex(for scrollView: UIScrollView) -> Int {
        return Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }

}
