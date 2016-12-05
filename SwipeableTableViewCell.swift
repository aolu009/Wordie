//
//  SwipeableTableViewCell.swift
//  Wordie
//
//  Created by parry on 12/3/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit

class SwipeableTableViewCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!

}

extension SwipeableTableViewCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
}
