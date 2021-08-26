//
//  SearchViewController.swift
//  GithubSearchList
//
//  Created by jacob on 2021/08/26.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum SearchCellIdentifier: String, CaseIterable {
    case repositoryCell = "RepositoryCell"
}

class SearchViewController: UIViewController {
    private var disposeBag: DisposeBag = DisposeBag()
    var viewModel: SearchViewModel = SearchViewModel()

    private var cachedCell: UICollectionViewCell?

    @IBOutlet weak var searchTextField: UITextField!

    @IBOutlet weak var collectionView: UICollectionView!

    @IBAction func clickedSearchButton(_ sender: Any) {
        search(text: searchTextField.text)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        bind()
    }

    private func initView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        for cell in SearchCellIdentifier.allCases {
            let identifier = cell.rawValue
            collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
        }

        viewModel.delegate = self
    }

    private func bind() {
        let filterWhiteSpace: (String?) -> Bool = { text in
            (text?.isEmpty == true || text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true) ? false : true
        }

        searchTextField.rx.controlEvent(.editingChanged)
            .map({ [weak self] _ -> String? in
                guard let self = self else {
                    return nil
                }

                return self.searchTextField.text
            })
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .filter(filterWhiteSpace)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else {
                    return
                }

                self.search(text: text)
            }).disposed(by: disposeBag)
    }

    private func search(text: String?) {

        if let text = text {
            self.viewModel.reset()
            self.collectionView.reloadData()
            self.viewModel.text = text
            self.viewModel.request()
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if collectionView.contentSize.height > 0, (collectionView.contentSize.height - offsetY) <= (200 + collectionView.frame.height) {
            viewModel.request()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCellIdentifier.repositoryCell.rawValue, for: indexPath) as? RepositoryCell {
            let item = viewModel.repositories[indexPath.row]
            cell.bind(item)
            return cell
        }

        return UICollectionViewCell()
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let identifier = SearchCellIdentifier.repositoryCell.rawValue
        if cachedCell == nil {
            guard let cell = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)?.first as? UICollectionViewCell else {
                return CGSize.zero
            }

            cachedCell = cell
        }

        let cellWidth = collectionView.frame.width
        if let repositoryCell = cachedCell as? RepositoryCell {
            let item = viewModel.repositories[indexPath.row]
            repositoryCell.fullnameLabel.text = item.fullName
            repositoryCell.descriptionLabel.text = item.itemDescription

            return CGSize(width: cellWidth, height: repositoryCell.heightFor(cellWidth))
        }

        return CGSize(width: cellWidth, height: 0)
    }
}

extension SearchViewController: SearchDelegate {
    func reloadData() {
        collectionView.reloadData()
    }

    func error(error: Error) {

    }


}
