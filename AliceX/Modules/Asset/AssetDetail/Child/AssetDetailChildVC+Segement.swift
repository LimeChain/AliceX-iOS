//
//  AssetDetailChildVC+Segement.swift
//  AliceX
//
//  Created by lmcmz on 6/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import Foundation

extension AssetDetailChildVC: JXPagingViewDelegate {
    func tableHeaderViewHeight(in _: JXPagingView) -> Int {
        return JXTableHeaderViewHeight
    }

    func tableHeaderView(in _: JXPagingView) -> UIView {
        return userHeaderContainerView
    }

    func heightForPinSectionHeader(in _: JXPagingView) -> Int {
        return JXheightForHeaderInSection
    }

    func viewForPinSectionHeader(in _: JXPagingView) -> UIView {
        return segmentedView
    }

    func numberOfLists(in _: JXPagingView) -> Int {
        return titles.count
    }

    func pagingView(_: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        
        let tab = AssetTab(rawValue: index)
        
        switch tab {
        case .transaction:
            let vc = AssetTXViewController.loadFromNib()
            return vc
        case .price:
            let vc = AssetPriceViewController()
            vc.loadViewIfNeeded()
            return vc
        case .info:
            let vc = AssetInfoViewController()
            vc.loadViewIfNeeded()
            return vc
        case .none:
            return AssetTXViewController.loadFromNib()
        }
    }

    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
        userHeaderView?.scrollViewDidScroll(contentOffsetY: scrollView.contentOffset.y)

        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if let ref = detailRef {
            ref.mainTabScroll(offset: translation.y)
        }
    }
}
