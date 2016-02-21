//
//  ViewController.swift
//  DesignPatternByRay
//
//  Created by Hiep Nguyen on 2/20/16.
//  Copyright © 2016 Zyncas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var dataTable: UITableView!
    
    @IBOutlet var toolbar: UIToolbar!
    
    private var allAlbums = [Album]()
    
    private var currentAlbumData: (titles: [String], values: [String])?
    
    private var currentAlbumIndex = 0

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false
        
        currentAlbumIndex = 0
        
        allAlbums = LibraryAPI.sharedInstance.getAlbums()
        
        dataTable.delegate = self
        
        dataTable.dataSource = self
        
        dataTable.backgroundView = nil
        
        view.addSubview(dataTable)
        
        showDataForAlbum(currentAlbumIndex)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showDataForAlbum(albumIndex: Int) {
        
        if (albumIndex < allAlbums.count && albumIndex > -1) {
            
            let album = allAlbums[albumIndex]
            
            currentAlbumData = album.ae_tableRepresentation()
        
        } else {
            
            currentAlbumData = nil
        }
        
        dataTable.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let albumData = currentAlbumData {
            
            return albumData.titles.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if let albumData = currentAlbumData {
            
            cell.textLabel?.text = albumData.titles[indexPath.row]
            
            cell.detailTextLabel?.text = albumData.values[indexPath.row]
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    
}
























