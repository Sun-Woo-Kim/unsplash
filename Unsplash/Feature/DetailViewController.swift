//
//  DetailViewController.swift
//  Unsplash
//
//  Created by Harry Kim on 6/27/20.
//  Copyright © 2020 sunwoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class DetailViewController: UIViewController {
 
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    private let disposeBag = DisposeBag()
    var viewModel: MainViewModelType!
    var selectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = viewModel.outputs.selectedIndexPath.value
        
        viewModel.outputs.selectedIndexPath.bind { [weak self] indexPath in
            guard let self = self else { return }
            guard let indexPath = indexPath else {
                self.titleLabel.text = ""
                return
            }
            self.titleLabel.text = self.viewModel.outputs.items.value[indexPath.row].user.name ?? ""
        }.disposed(by: disposeBag)
        
        bindCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            if let selectedIndex = self.selectedIndex {
                self.collectionView.scrollToItem(at: selectedIndex, at: .left, animated: false)
            }
        }
    }
 
    func bindCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = collectionView.frame.size
        layout.minimumLineSpacing = 0
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.isPagingEnabled = true
        collectionView.setCollectionViewLayout(layout, animated: true)
    
        viewModel.outputs.items
            .bind(to: collectionView.rx.items(cellIdentifier: "cell", cellType: PhotoCollectionCell.self)) {
                index, model, cell in
                cell.photoImageView.contentMode = .scaleAspectFit 
                cell.photoImageView.kf.setImage(with: URL(string: model.urls.regular))
        }.disposed(by: disposeBag)
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currnetRow = Int(collectionView.contentOffset.x / collectionView.frame.size.width)
        viewModel.inputs.select(indexPath: .init(row: currnetRow, section: 0))
    }
}
