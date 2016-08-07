//
// Created by Maciej Oczko on 31.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

protocol ScrollViewPageMetricsType {
    func isFirstPageOfScrollView(scrollView: UIScrollView) -> Bool
    func isLastPageOfScrollView(scrollView: UIScrollView) -> Bool
    func currentPageIndexForScrollView(scrollView: UIScrollView) -> Int
}

final class ScrollViewPageMetrics: ScrollViewPageMetricsType {

    func isFirstPageOfScrollView(scrollView: UIScrollView) -> Bool {
        return scrollView.contentOffset.x < scrollView.frame.size.width
    }
    
    func isLastPageOfScrollView(scrollView: UIScrollView) -> Bool {
        return scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width)
    }

    func currentPageIndexForScrollView(scrollView: UIScrollView) -> Int {
        return Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }

}
