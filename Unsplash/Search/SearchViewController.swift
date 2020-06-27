//
//  SearchViewController.swift
//  Unsplash
//
//  Created by Harry Kim on 2020/06/25.
//  Copyright © 2020 sunwoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import Hero

class SearchViewController: UIViewController, UISearchBarDelegate {

    let disposeBag = DisposeBag()

    private let viewModel: SearchViewModelType = SearchViewModel()

    @IBOutlet private weak var tableView: UITableView!

    private var searchController: UISearchController = UISearchController(searchResultsController: nil)

    private var isShowingDetail = false

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.rx.setDelegate(self).disposed(by: disposeBag)
        searchController.hidesNavigationBarDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true

        bindSearchBar()
        bindTableView()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        isShowingDetail = false
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let model: PhotoInfo = try? tableView.rx.model(at: indexPath) else { return UITableView.automaticDimension }
        let height = view.bounds.width * CGFloat(model.height) / CGFloat(model.width)
        return height
    }
}

extension SearchViewController {

    func bindTableView() {
        tableView.separatorStyle = .none
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        viewModel.outputs.items
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: PhotoCell.self) ) {
                [weak self] index, model, cell in
                guard let self = self else { return }

                cell.selectionStyle = .none
                //cell.hero.isEnabledForSubviews = false

                cell.photoImageView.kf.indicatorType = .activity
                cell.photoImageView.contentMode = .scaleToFill
                cell.photoImageView.kf.setImage(with: URL(string: model.urls.regular))
                //cell.photoImageView.hero.id = HeroStyle.image.apply

                cell.userLabel.text = model.user.name ?? ""
                //cell.userLabel.hero.id = HeroStyle.title.apply

                let itemCount = self.viewModel.outputs.items.value.count
                if itemCount - index < 7 {
                    self.viewModel.inputs.fetchNext()
                }

        }.disposed(by: disposeBag)

        tableView.rx.itemSelected
            .observeOn(MainScheduler.instance)
            .bind {  [weak self] indexPath in
                guard let self = self else {return }
                let cell = self.tableView.cellForRow(at: indexPath)
                cell?.hero.isEnabledForSubviews = true

                self.isShowingDetail = true

//                self.navigationController.hero.isEnabled = true
//                self.navigationController.pushViewController(viewController, animated: true)
        }.disposed(by: disposeBag)

    }

    func bindSearchBar() {
        searchController.searchBar.rx.text
            .orEmpty
            .changed
            .filter { _ in !self.isShowingDetail }.bind { text in
                self.navigationItem.title = text
                self.viewModel.inputs.search(by: text)

        }
            .disposed(by: disposeBag)

        searchController.rx.willDismiss
            .compactMap { self.searchController.searchBar.text }
            .observeOn(MainScheduler.asyncInstance)
            .bind { text in
                self.navigationItem.title = text
                self.searchController.searchBar.text = text
                self.viewModel.inputs.search(by: text)
        }.disposed(by: disposeBag)
    }
}

