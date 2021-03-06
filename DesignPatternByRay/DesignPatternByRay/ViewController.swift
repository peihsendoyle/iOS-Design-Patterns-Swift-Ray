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
    
    @IBOutlet weak var scroller: HorizontalScroller!
    
    private var allAlbums = [Album]()
    
    private var currentAlbumData: (titles: [String], values: [String])?
    
    private var currentAlbumIndex = 0
    
    var undoStack : [(Album, Int)] = []

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false
        
//        currentAlbumIndex = 0
        
        allAlbums = LibraryAPI.sharedInstance.getAlbums()
        
        dataTable.delegate = self
        
        dataTable.dataSource = self
        
        dataTable.backgroundView = nil
        
        view.addSubview(dataTable)
        
 //       showDataForAlbum(currentAlbumIndex)
        
        loadPreviousState()
        
        scroller.delegate = self
        
        reloadScroller()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveCurrentState", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Momento Pattern
    
    func saveCurrentState() {
        
        NSUserDefaults.standardUserDefaults().setInteger(currentAlbumIndex, forKey: "currentAlbumIndex")
        
        LibraryAPI.sharedInstance.saveAlbums()
    }
    
    func loadPreviousState() {
        
        currentAlbumIndex = NSUserDefaults.standardUserDefaults().integerForKey("currentAlbumIndex")
        
        showDataForAlbum(currentAlbumIndex)
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
    
    func reloadScroller() {
        
        allAlbums = LibraryAPI.sharedInstance.getAlbums()
        
        if currentAlbumIndex < 0 {
            
            currentAlbumIndex = 0
            
        } else if currentAlbumIndex > allAlbums.count {
            
            currentAlbumIndex = allAlbums.count - 1
        }
        
        scroller.reload()
        
        showDataForAlbum(currentAlbumIndex)
        
        let undoButton = UIBarButtonItem(barButtonSystemItem: .Undo, target: self, action: "undoAction")
        
        undoButton.enabled = false
        
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        let trashButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "deleteAlbum")
        
        let toolbarButtonItem = [undoButton, space, trashButton]
        
        toolbar.setItems(toolbarButtonItem, animated: true)
    }
    
    func addAlbumAtIndex(album: Album, index: Int) {
        
        LibraryAPI.sharedInstance.addAlbum(album, index: index)
        
        currentAlbumIndex = index
        
        reloadScroller()
    }
    
    func deleteAlbum() {
        
        let deletedAlbum: Album = allAlbums[currentAlbumIndex]
        
        let undoAction = (deletedAlbum, currentAlbumIndex)
        
        undoStack.insert(undoAction, atIndex: 0)
        
        LibraryAPI.sharedInstance.deleteAlbum(currentAlbumIndex)
        
        reloadScroller()
        
        let barButtonItems = toolbar.items! as [UIBarButtonItem]
        
        let undoButton: UIBarButtonItem = barButtonItems[0]
        
        undoButton.enabled = true
        
        if allAlbums.count == 0 {
            
            let trashButton : UIBarButtonItem = barButtonItems [2]
            
            trashButton.enabled = false
        }
    }
    
    func undoAction() {
        
        let barButtonItems = toolbar.items! as [UIBarButtonItem]
        
        if undoStack.count > 0 {
            
            let (deletedAlbum, index) = undoStack.removeAtIndex(0)
            
            addAlbumAtIndex(deletedAlbum, index: index)
            
        }
        
        if undoStack.count == 0 {
            
            let undoButton: UIBarButtonItem = barButtonItems[0]
            
            undoButton.enabled = false
        }
        
        let trashButton: UIBarButtonItem = barButtonItems[2]
        
        trashButton.enabled = true
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

extension ViewController: HorizontalScrollerDelegate {
    
    func horizontalScrollerClickedViewAtIndex(scroller: HorizontalScroller, index: Int) {
        
        let previousAlbumView = scroller.viewAtIndex(currentAlbumIndex) as! AlbumView
        
        previousAlbumView.highlightAlbum(false)
        
        currentAlbumIndex = index
        
        let albumView = scroller.viewAtIndex(index) as! AlbumView
        
        albumView.highlightAlbum(true)
        
        showDataForAlbum(index)
    }
    
    func numberOfViewsForHorizontalScroller(scroller: HorizontalScroller) -> Int {
        
        return allAlbums.count
    }
    
    func horizontalScrollerViewAtIndex(scroller: HorizontalScroller, index: Int) -> UIView {
        
        let album = allAlbums[index]
        
        let albumView = AlbumView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), albumCover: album.coverURL)
        
        if currentAlbumIndex == index {
            
            albumView.highlightAlbum(true)
        } else {
            
            albumView.highlightAlbum(false)
        }
        
        return albumView
    }
    
    func initialViewIndex(scroller: HorizontalScroller) -> Int {
        
        return currentAlbumIndex
    }

}

























