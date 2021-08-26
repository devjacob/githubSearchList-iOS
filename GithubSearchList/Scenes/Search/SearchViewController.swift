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
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCellIdentifier.repositoryCell.rawValue, for: indexPath) as? RepositoryCell {

            return cell
        }

        return UICollectionViewCell()
    }
}

extension SearchViewController: SearchDelegate {
    func reloadData() {
        collectionView.reloadData()
    }

    func error(error: Error) {

    }


}
