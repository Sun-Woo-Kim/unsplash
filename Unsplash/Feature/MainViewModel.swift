//
//  MainViewModel.swift
//  Unsplash
//
//  Created by Harry Kim on 2020/06/25.
//  Copyright © 2020 sunwoo. All rights reserved.
//
 
import RxSwift
import RxCocoa

protocol MainViewModelType {
    var inputs: MainViewModelInput { get }
    var outputs: MainViewModelOutput { get }
}

protocol MainViewModelInput {
    func search(by text: String)
    func fetchNext()
    func refresh()
    func select(indexPath: IndexPath?)
}

protocol MainViewModelOutput {
    var error: PublishRelay<Error> { get }
    var items: BehaviorRelay<[PhotoInfo]> { get }
    var selectedIndexPath: BehaviorRelay<IndexPath?> { get }
}

class MainViewModel: MainViewModelType, MainViewModelInput, MainViewModelOutput {
    
    var selectedIndexPath: BehaviorRelay<IndexPath?> = .init(value: nil)
     
    private let disposeBag = DisposeBag()

    var inputs: MainViewModelInput { return self }
    var outputs: MainViewModelOutput { return self }

    let items: BehaviorRelay<[PhotoInfo]> = .init(value: [])
    let error: PublishRelay<Error> = .init()

    private var currentPage: Int = 0

    private var didSetEndPage: Bool = false

    private var isRequesting = false

    private var _page: Int = 0
    private var page: Int {
        get {
            _page += 1
            return _page
        }
        set {
            _page = newValue
        }
    }

    private let searchTextProperty: BehaviorRelay<String> = .init(value: "")
    init() {
        searchTextProperty
            .debounce(.milliseconds(200), scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .bind{ text in
                NetworkManager.cancelAllRequest()
                self.didSetEndPage = false
                self.isRequesting = false
                self.page = 0
                self.items.accept([])

                if text.isEmpty {
                    self.getPhotoList()
                } else {
                    self.getSearchInfo(by: text)
                }
            }
            .disposed(by: disposeBag)
    }
}
extension MainViewModel {

    func search(by text: String) {
        searchTextProperty.accept(text)
    }

    func fetchNext() {
        guard !isRequesting, !didSetEndPage, items.value.count > 0 else { return }
        if searchTextProperty.value.isEmpty {
           getPhotoList()
        } else {
            getSearchInfo(by: searchTextProperty.value)
        }
    }

    func refresh() {
        items.accept(items.value)
    }

    func getSearchInfo(by text: String) {
        isRequesting = true
        NetworkManager.getPhotoSearchInfo(request: .init(page: page, query: text))
            .asObservable()
            .compactMap { $0.results }
            .subscribe(
                onNext: { [weak self] photoInfos in
                    guard let self = self else { return }

                    guard photoInfos.count > 0 else {
                        self.didSetEndPage = true
                        return
                    }

                    let oldInfos = self.items.value
                    self.items.accept(oldInfos + photoInfos) },

                onError: { [weak self] error in
                    self?.error.accept(error) },

                onDisposed: { [weak self] in
                    self?.isRequesting = false

            }).disposed(by: disposeBag)
    }

    func getPhotoList() {
        isRequesting = true
        NetworkManager.getPhotoListInfo(request: .init(page: page, query: nil))
            .asObservable()
            .subscribe(
                onNext: { [weak self] photoInfos in
                    guard let self = self else { return }

                    guard photoInfos.count > 0 else {
                        self.didSetEndPage = true
                        return
                    }

                    let oldInfos = self.items.value
                    self.items.accept(oldInfos + photoInfos) },

                onError: { [weak self] error in
                    self?.error.accept(error) },

                onDisposed: { [weak self] in
                    self?.isRequesting = false

            }).disposed(by: disposeBag)
    }

    func select(indexPath: IndexPath?) {
        self.selectedIndexPath.accept(indexPath)
    }
}
