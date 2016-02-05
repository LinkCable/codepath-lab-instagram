//
//  ViewController.swift
//  Moment
//
//  Created by Philippe Kimura-Thollander on 2/2/16.
//  Copyright © 2016 Philippe Kimura-Thollander. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var pictures: [NSDictionary]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Moment"
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
                            self.pictures = (responseDictionary["data"] as! [NSDictionary])
                            self.tableView.reloadData()
                    }
                }
        });
        task.resume()

        
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }


}

