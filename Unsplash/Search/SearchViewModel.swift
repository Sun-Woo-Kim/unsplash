//
//  SearchViewModel.swift
//  Unsplash
//
//  Created by Harry Kim on 2020/06/25.
//  Copyright © 2020 sunwoo. All rights reserved.
//
 
import RxSwift
import RxCocoa

protocol SearchViewModelType {
    var inputs: SearchViewModelInput { get }
    var outputs: SearchViewModelOutput { get }
}

protocol SearchViewModelInput {
    func search(by text: String)
    func fetchNext()
    func refresh()
}

protocol SearchViewModelOutput {
    var error: PublishRelay<Error> { get }
    var items: BehaviorRelay<[PhotoInfo]> { get }
}

class SearchViewModel: SearchViewModelType, SearchViewModelInput, SearchViewModelOutput {

    private let disposeBag = DisposeBag()

    var inputs: SearchViewModelInput { return self }
    var outputs: SearchViewModelOutput { return self }

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
                self.page = -1
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
extension SearchViewModel {

    func search(by text: String) {
        searchTextProperty.accept(text)
    }

    func fetchNext() {
        guard !isRequesting, !didSetEndPage else { return }
        getSearchInfo(by: searchTextProperty.value)
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
        NetworkManager.getPhotoListInfo()
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

}
