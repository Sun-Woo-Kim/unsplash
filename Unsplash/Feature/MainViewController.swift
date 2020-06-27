//
//  MainViewController.swift
//  Unsplash
//
//  Created by Harry Kim on 2020/06/25.
//  Copyright © 2020 sunwoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class MainViewController: UIViewController, UISearchBarDelegate {
    
    private let searchPhotoText = "Search Photos"
    private let disposeBag = DisposeBag()
    private let viewModel: MainViewModelType = MainViewModel()
    private var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet private weak var tableView: UITableView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
 
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.rx.setDelegate(self).disposed(by: disposeBag)
        searchController.hidesNavigationBarDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.title = searchPhotoText

        bindSearchBar()
        bindTableView()

    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let model: PhotoInfo = try? tableView.rx.model(at: indexPath) else { return UITableView.automaticDimension }
        return view.bounds.width * CGFloat(model.height) / CGFloat(model.width)
    }
}

extension MainViewController {
    func bindTableView() {
        tableView.separatorStyle = .none
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        viewModel.outputs.items
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: PhotoCell.self) ) {
                [weak self] index, model, cell in
                guard let self = self else { return }

                cell.selectionStyle = .none

                cell.photoImageView.kf.indicatorType = .activity
                cell.photoImageView.contentMode = .scaleToFill
                cell.photoImageView.kf.setImage(with: URL(string: model.urls.regular))

                cell.userLabel.text = model.user.name ?? ""

                let itemCount = self.viewModel.outputs.items.value.count
                if itemCount - index < 7 {
                    self.viewModel.inputs.fetchNext()
                }

        }.disposed(by: disposeBag)

        tableView.rx.itemSelected
            .bind {  [weak self] indexPath in
                guard let self = self else { return }
                self.viewModel.inputs.select(indexPath: indexPath)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let viewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
                viewController.viewModel = self.viewModel
                self.present(viewController, animated: true)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.selectedIndexPath
            .compactMap { $0 }
            .bind { [weak self] indexPath in
                self?.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }.disposed(by: disposeBag)
    }

    func bindSearchBar() {
        searchController.searchBar.rx.text
            .orEmpty
            .changed
            .bind { [weak self] text in self?.setSearchText(with: text) }
            .disposed(by: disposeBag)

        searchController.rx.willDismiss
            .compactMap { self.searchController.searchBar.text }
            .observeOn(MainScheduler.asyncInstance)
            .bind { [weak self] text in
                self?.searchController.searchBar.text = text
                self?.setSearchText(with: text)
        }.disposed(by: disposeBag)
    }
    
    func setSearchText(with text: String) {
        self.navigationItem.title = text.isEmpty ? self.searchPhotoText : text
        self.viewModel.inputs.search(by: text)
    }
}

