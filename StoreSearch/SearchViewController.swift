//
//  ViewController.swift
//  StoreSearch
//
//  Created by Hans Ravnaas on 11/16/16.
//  Copyright © 2016 Hans Ravnaas. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
	
	struct TableViewCellIdentifiers
	{
		static let searchResultCell = "SearchResultCell"
		static let nothingFoundCell = "NothingFoundCell"
		static let loadingCell = "LoadingCell"
	}
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	var landscapeViewController: LandscapeViewController?
	let search = Search()
	
	@IBAction func segmentChanged(_ sender: UISegmentedControl)
	{
		performSearch()
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		searchBar.becomeFirstResponder()
		tableView.rowHeight = 80
		tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
		
		// Register cells with real data.
		var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
		tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
		
		// Register "not found" cell.
		cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
		tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
		
		// Register "Loading..." cell.
		cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
		tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func showNetworkError()
	{
		let alert = UIAlertController(
			title: "Whoops...",
			message:
			"There was an error communicating with the iTunes Store. Please try again.",
			preferredStyle: .alert
		)
		
		let action = UIAlertAction(title: "OK", style: .default, handler: nil)
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if segue.identifier == "ShowDetail"
		{
			if case .results(let list) = search.state
			{
				let detailViewController = segue.destination as! DetailViewController
				let indexPath = sender as! IndexPath
				let searchResult = list[indexPath.row]
				detailViewController.searchResult = searchResult
			}
		}
	}
	
	override func willTransition(
		to newCollection: UITraitCollection,
		with coordinator: UIViewControllerTransitionCoordinator)
	{
		super.willTransition(to: newCollection, with: coordinator)
		
		switch newCollection.verticalSizeClass
		{
			case .compact:
				showLandscape(with: coordinator)
			case .regular, .unspecified:
				hideLandscape(with: coordinator)
		}
	}
	
	func hideLandscape(with coordinator: UIViewControllerTransitionCoordinator)
	{
		if let controller = landscapeViewController
		{
			controller.willMove(toParentViewController: nil)
			coordinator.animate(
				alongsideTransition:
				{
					_ in
					controller.view.alpha = 0
					//self.searchBar.resignFirstResponder()
					if self.presentedViewController != nil
					{
						self.dismiss(animated: true, completion: nil)
					}
				},
				completion:
				{ _ in
					controller.view.removeFromSuperview()
					controller.removeFromParentViewController()
					self.landscapeViewController = nil
				}
			)
		}
	}
	
	func showLandscape(
		with coordinator: UIViewControllerTransitionCoordinator)
	{
		guard landscapeViewController == nil else { return }
		landscapeViewController = storyboard!.instantiateViewController(
			withIdentifier: "LandscapeViewController") as? LandscapeViewController
		if let controller = landscapeViewController
		{
			controller.search = search
			controller.view.frame = view.bounds
			controller.view.alpha = 0
			view.addSubview(controller.view)
			addChildViewController(controller)
			coordinator.animate(alongsideTransition:
				{ _ in
					controller.view.alpha = 1
					self.searchBar.resignFirstResponder()
					if self.presentedViewController != nil
					{
						self.dismiss(animated: true, completion: nil)
					}
				},
				completion:
				{ _ in
				controller.didMove(toParentViewController: self)
				}
			)
		}
	}

}

////////////////// Extensions /////////////////////////

extension SearchViewController: UISearchBarDelegate
{
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
	{
		performSearch()
	}
	
	func performSearch()
	{
		if let category = Search.Category(rawValue: segmentedControl.selectedSegmentIndex)
		{
			search.performSearch(
				for: searchBar.text!,
				category: category,
				completion:
				{
					success in
					if !success
					{
						self.showNetworkError()
					}
					self.tableView.reloadData()
					self.landscapeViewController?.searchResultsReceived()
				}
			)
		}
		tableView.reloadData()
		searchBar.resignFirstResponder()
	}
} // end extension

extension SearchViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		switch search.state
		{
			case .notSearchedYet:
				return 0
			case .loading:
				return 1
			case .noResults:
				return 1
			case .results(let list):
				return list.count
		}
	}

	func tableView(_ tableView: UITableView,
	               cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		switch search.state
		{
			case .notSearchedYet:
				fatalError("Should never get here")
			case .loading:
				let cell = tableView.dequeueReusableCell(
					withIdentifier: TableViewCellIdentifiers.loadingCell,
					for: indexPath)
				let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
				spinner.startAnimating()
				return cell
			case .noResults:
				return tableView.dequeueReusableCell(
					withIdentifier: TableViewCellIdentifiers.nothingFoundCell,
					for: indexPath)
			case .results(let list):
				let cell = tableView.dequeueReusableCell(
					withIdentifier: TableViewCellIdentifiers.searchResultCell,
					for: indexPath) as! SearchResultCell
				let searchResult = list[indexPath.row]
				cell.configure(for: searchResult)
				return cell
		}
	}
	
	func position(for bar: UIBarPositioning) -> UIBarPosition
	{
		return .topAttached
	}
	
} // end extension

extension SearchViewController: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		tableView.deselectRow(at: indexPath, animated: true)
		performSegue(withIdentifier: "ShowDetail", sender: indexPath)
	}
	
	func tableView(_ tableView: UITableView,
	               willSelectRowAt indexPath: IndexPath) -> IndexPath?
	{
		switch search.state
		{
			case .notSearchedYet, .loading, .noResults:
				return nil
			case .results:
				return indexPath
		}
	}
} // end extension

