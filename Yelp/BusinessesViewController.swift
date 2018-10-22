//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate {
    var isMoreDataLoading = false
    var currentOffset = 0
    var businesses: [Business]!
    var selectedBusiness: Business?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 120
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Business.searchWithTerm(term: "boba", completion: { (businesses, error) -> Void in
            
                self.businesses = businesses
                if let businesses = businesses {
                    for business in businesses {
                        self.tableView.reloadData()
                        print(business.name!)
                        print(business.address!)
                    }
                }
            
            }
        )
        
        createSearchBar()
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm(term: "Restaurants", sort: .distance, categories: ["asianfusion", "burgers"]) { (businesses, error) in
                self.businesses = businesses
                 for business in self.businesses {
                     print(business.name!)
                     print(business.address!)
                 }
         }
         */
        
    }
    
    func createSearchBar() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Yelp Search"
        self.navigationItem.titleView = searchBar
    }
    
    // MARK: - UITableView datasource and delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCellTableViewCell
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBusiness = businesses[indexPath.row]
        performSegue(withIdentifier: "ShowBusinessDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - UIScrollView Delegate methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            // When the user has scrolled past the threshold, start requesting
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                // Load more results
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        currentOffset+=20
        Business.searchWithTerm(term: "boba",offset:currentOffset,completion: { (businesses, error) -> Void in
            self.isMoreDataLoading = false
            self.businesses.append(contentsOf:businesses!)
            if let businesses = businesses {
                for business in businesses {
                    self.tableView.reloadData()
                    print(business.name!)
                    print(business.address!)
                }
            }
            
        }
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch(identifier) {
            case "ShowMap":
                if let dvc = segue.destination as? MapViewController {
                    dvc.businesses = self.businesses
                }
            case "ShowBusinessDetail":
                if let dvc = segue.destination as? BusinessDetailViewController {
                    dvc.business = selectedBusiness
                }
            default:
                break
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
