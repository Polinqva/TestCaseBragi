//
//  TVShowsViewController.swift
//  TestCaseBragi
//
//  Created by Polina Smirnova on 28.04.2025.
//
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

class TVShowsViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    private let viewModel = TVShowsViewModel()
    private let disposeBag = DisposeBag()
    
    private let refreshControl = UIRefreshControl()
    private var genresCollectionView: UICollectionView!
    private var itemsCollectionView: UICollectionView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        title = "TV Shows"
        view.backgroundColor = .white
        
        let genresLayout = UICollectionViewFlowLayout()
        genresLayout.scrollDirection = .horizontal
        genresLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        genresLayout.minimumLineSpacing = 8
        genresLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        genresCollectionView = UICollectionView(frame: .zero, collectionViewLayout: genresLayout)
        
        
        genresCollectionView = UICollectionView(frame: .zero, collectionViewLayout: genresLayout)
        genresCollectionView.backgroundColor = .clear
        genresCollectionView.showsHorizontalScrollIndicator = false
        genresCollectionView.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.identifier)
        
        view.addSubview(genresCollectionView)
        
        genresCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let itemsLayout = UICollectionViewFlowLayout()
        itemsLayout.scrollDirection = .vertical
        itemsLayout.minimumLineSpacing = 8
        itemsLayout.minimumInteritemSpacing = 8
        itemsLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        itemsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: itemsLayout)
        itemsCollectionView.backgroundColor = .white
        itemsCollectionView.refreshControl = refreshControl
        itemsCollectionView.register(TVShowItemCell.self, forCellWithReuseIdentifier: TVShowItemCell.identifier)
        itemsCollectionView.delegate = self
        
        view.addSubview(itemsCollectionView)
        
        itemsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(genresCollectionView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        // Bind genres
        viewModel.genres
            .bind(to: genresCollectionView.rx.items(cellIdentifier: GenreCell.identifier, cellType: GenreCell.self)) { row, genre, cell in
                cell.configure(with: genre)
            }
            .disposed(by: disposeBag)
        
        genresCollectionView.rx.modelSelected(Genre.self)
            .bind(to: viewModel.selectGenreTrigger)
            .disposed(by: disposeBag)
        
        // Bind items
        viewModel.items
            .do(onNext: { items in
            })
            .bind(to: itemsCollectionView.rx.items(cellIdentifier: TVShowItemCell.identifier, cellType: TVShowItemCell.self)) { [weak self] row, item, cell in
                guard let self = self else { return }
                
                APIService.shared.fetchDetails(for: .tv, id: item.id)
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { detail in
                        cell.configure(with: item, detail: detail)
                    }, onError: { error in
                        cell.configure(with: item, detail: nil)
                    })
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        
        // Infinite scroll
        itemsCollectionView.rx.contentOffset
            .subscribe(onNext: { [weak self] offset in
                guard let self = self else { return }
                let threshold: CGFloat = 100.0
                let contentHeight = self.itemsCollectionView.contentSize.height
                let frameHeight = self.itemsCollectionView.frame.size.height
                let offsetY = offset.y
                if offsetY > contentHeight - frameHeight - threshold {
                    self.viewModel.loadMoreTrigger.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        // Pull to refresh
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.refreshTrigger)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .subscribe(onNext: { [weak self] loading in
                if !loading {
                    self?.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
        // Handle errors
        viewModel.error
            .subscribe(onNext: { error in
                print("Error:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == itemsCollectionView {
            let spacing: CGFloat = 8
            let columns: CGFloat = 2
            let totalSpacing = spacing * (columns + 1)
            let width = (collectionView.bounds.width - totalSpacing) / columns
            return CGSize(width: width, height: 230)
        } else {
            return CGSize(width: 80, height: 34)
        }
    }
}
