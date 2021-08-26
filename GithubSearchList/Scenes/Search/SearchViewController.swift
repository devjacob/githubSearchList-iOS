//
//  SearchViewController.swift
//  GithubSearchList
//
//  Created by jacob on 2021/08/26.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    var viewModel: SearchViewModel = SearchViewModel()

    @IBOutlet weak var searchTextField: UITextField!

    @IBOutlet weak var collectionView: UICollectionView!

    @IBAction func clickedSearchButton(_ sender: Any) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    private func initView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        viewModel.delegate = self
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
