//
//  BaseMediaViewModel.swift
//  TestCaseBragi
//
//  Created by Polina Smirnova on 28.04.2025.
//

import Foundation
import RxSwift
import RxCocoa

class BaseMediaViewModel: NSObject {
    
    // MARK: - Inputs
    let refreshTrigger = PublishSubject<Void>()
    let loadMoreTrigger = PublishSubject<Void>()
    let selectGenreTrigger = PublishSubject<Genre>()
    
    // MARK: - Outputs
    let genres = BehaviorRelay<[Genre]>(value: [])
    let items = BehaviorRelay<[MediaItem]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishSubject<Error>()
    
    // MARK: - Internals
    private let mediaType: MediaType
    private let disposeBag = DisposeBag()
    private var currentPage = 1
    private var selectedGenre: Genre?
    private var isLastPage = false
    
    init(mediaType: MediaType) {
        self.mediaType = mediaType
        super.init()
        bind()
        fetchGenres()
    }
    
    private func bind() {
        refreshTrigger
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.isLastPage = false
                self.items.accept([])
                if self.selectedGenre != nil {
                    self.fetchItems(randomPage: true)
                } else {
                    self.fetchGenres()
                }
            })
            .disposed(by: disposeBag)
        
        loadMoreTrigger
            .subscribe(onNext: { [weak self] in
                self?.loadNextPage()
            })
            .disposed(by: disposeBag)
        
        selectGenreTrigger
            .subscribe(onNext: { [weak self] genre in
                guard let self = self else { return }
                self.selectedGenre = genre
                self.currentPage = 1
                self.isLastPage = false
                self.items.accept([])
                self.fetchItems()
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchGenres() {
        isLoading.accept(true)
        
        APIService.shared.fetchGenres(for: mediaType)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] genres in
                guard let self = self else { return }
                self.genres.accept(genres)
                self.isLoading.accept(false)
                if let first = genres.first {
                    self.selectGenreTrigger.onNext(first)
                }
            }, onError: { [weak self] error in
                self?.isLoading.accept(false)
                self?.error.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchItems(randomPage: Bool = false) {
        guard let genre = selectedGenre else { return }
        guard !isLoading.value else { return }
        
        if randomPage {
            currentPage = Int.random(in: 1...10)
        }
        
        isLoading.accept(true)
        
        APIService.shared.fetchItems(for: mediaType, genreId: genre.id, page: currentPage)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] newItems in
                guard let self = self else { return }
                let updated = self.currentPage == 1 ? newItems : self.items.value + newItems
                self.items.accept(updated)
                self.isLoading.accept(false)
                if newItems.isEmpty {
                    self.isLastPage = true
                }
            }, onError: { [weak self] error in
                self?.isLoading.accept(false)
                self?.error.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadNextPage() {
        guard !isLastPage, !isLoading.value else { return }
        currentPage += 1
        fetchItems()
    }
}
