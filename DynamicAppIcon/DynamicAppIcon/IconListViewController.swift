//
//  IconListViewController.swift
//  DynamicAppIcon
//
//  Created by Muhammed Nadeem on 29/06/24.
//

import UIKit

class IconCell: UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
}

class IconListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var icons: [Icon] = Icon.getIcons()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func resetAction(_ sender: UIButton) {
        //Pass nil to set the default App icon in the xcasset folder
        AppIconManager().setAppIcon(nil)
    }
    
}

//Collectionview delegate and datasource
extension IconListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCell", for: indexPath) as! IconCell
        cell.imageView.image = UIImage(named: icons[indexPath.row].rawValue)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 3) - 10 , height: (collectionView.frame.size.width / 3) + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AppIconManager().setAppIcon(icons[indexPath.row].rawValue)
    }
    
}
