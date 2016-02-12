//
//  ViewController.swift
//  Moment
//
//  Created by Philippe Kimura-Thollander on 2/2/16.
//  Copyright © 2016 Philippe Kimura-Thollander. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var pictures: [NSDictionary]?
    var loadingMoreView:InfiniteScrollActivityView?
    var requestingData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Moment"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        requestData()
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell;
        let picture = pictures![indexPath.section]
        let imageUrl = NSURL( string: picture.valueForKeyPath("images.standard_resolution.url") as! String)
        cell.pictureView.setImageWithURL(imageUrl!)
        cell.selectionStyle = .None
        
        return cell;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let pictures = pictures {
            return pictures.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        
        // Use the section number to get the right URL
        let profile = pictures![section]
        let profilePictureUrl = NSURL(string: profile.valueForKeyPath("user.profile_picture") as! String)
        profileView.setImageWithURL(profilePictureUrl!)
        
        headerView.addSubview(profileView)
        
        // Add a UILabel for the username here
        let profileName = UILabel(frame: CGRect(x: 50, y: 10, width: 200, height: 30))
        profileName.clipsToBounds = true
        profileName.textColor = UIColor(red:33/255.0, green:146/255.0, blue:255/255.0, alpha: 1.0)
        profileName.text = profile.valueForKeyPath("user.username") as? String
        
        headerView.addSubview(profileName)
        
        return headerView
    }
    
    func requestData() {
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            if(self.pictures != nil) {
                                self.pictures! += (responseDictionary["data"] as! [NSDictionary])
                            }
                            else {
                                self.pictures = (responseDictionary["data"] as! [NSDictionary])
                            }
                            self.loadingMoreView!.stopAnimating()
                            self.requestingData = false
                            self.tableView.reloadData()
                    }
                }
        });
        task.resume()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!requestingData) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                requestingData = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                requestData()
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! PhotoDetailsViewController
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let picture = pictures![indexPath!.section]
        vc.photo = picture
        
    }


}

