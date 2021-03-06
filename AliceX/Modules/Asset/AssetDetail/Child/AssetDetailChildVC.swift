//
//  AssetDetailChildVC.swift
//  AliceX
//
//  Created by lmcmz on 5/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import JXSegmentedView
import UIKit

class AssetDetailChildVC: UIViewController {
    
    enum AssetTab: Int, CaseIterable {
        case transaction = 0
        case price
        case info
    }
    
    var pagingView: JXPagingView!
    var userHeaderView: AssetDetailHeader!
    var userHeaderContainerView: UIView!
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    var segmentedView: JXSegmentedView!
    let titles = ["Transactions", "Price", "Info"]
    var JXTableHeaderViewHeight: Int = 200
    var JXheightForHeaderInSection: Int = 50

    var detailRef: AssetDetailViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.delegate = self

        userHeaderContainerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(JXTableHeaderViewHeight)))
        userHeaderView = AssetDetailHeader.instanceFromNib()
        userHeaderContainerView.addSubview(userHeaderView)
        userHeaderView.fillSuperview()

        // segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.titleSelectedColor = AliceColor.white()
        segmentedViewDataSource.titleNormalColor = AliceColor.darkGrey()
        segmentedViewDataSource.isTitleColorGradientEnabled = true
//        segmentedViewDataSource.isTitleZoomEnabled = true
        segmentedViewDataSource.reloadData(selectedIndex: 0)

        segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(JXheightForHeaderInSection)))
        segmentedView.backgroundColor = AliceColor.white()
        segmentedView.dataSource = segmentedViewDataSource
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false

//        let indicator = JXSegmentedIndicatorLineView()
//        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
//        indicator.lineStyle = .lengthenOffset
//        indicator.indicatorColor = AliceColor.dark
//        segmentedView.indicators = [indicator]

        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.isIndicatorConvertToItemFrameEnabled = true
        indicator.indicatorHeight = 30
        indicator.indicatorColor = AliceColor.darkGrey()
        segmentedView.indicators = [indicator]

        let lineWidth = 1 / UIScreen.main.scale
        let lineLayer = CALayer()
        lineLayer.backgroundColor = AliceColor.greyNew().cgColor
        lineLayer.frame = CGRect(x: 0, y: segmentedView.bounds.height - lineWidth, width: segmentedView.bounds.width, height: lineWidth)
        segmentedView.layer.addSublayer(lineLayer)

        pagingView = JXPagingView(delegate: self)

        view.addSubview(pagingView)

        segmentedView.contentScrollView = pagingView.listContainerView.collectionView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pagingView.frame = view.bounds
    }
}

extension AssetDetailChildVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
}
