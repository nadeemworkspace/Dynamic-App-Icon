//
//  AppIconManager.swift
//  DynamicAppIcon
//
//  Created by Muhammed Nadeem on 29/06/24.
//

import UIKit
//import FirebaseRemoteConfig

enum Icon: String, CaseIterable{
    case AppleTV
    case Appstore
    case Calculator
    case Facetime
    case Help
    case Maps
    case Music
    case News
    case Shazam
    
    static func getIcons() -> [Icon] {
        return Array(self.allCases)
    }
}

class AppIconManager {
    
    //Returns the current app icon name
    private var currentAppIcon: String?{
        return UIApplication.shared.alternateIconName
    }
    
    func setAppIcon(_ icon: String?){
        if self.currentAppIcon != icon{
            self.setAppIconWithAlert(icon)
            //self.setAppIconWithoutAlert(icon)
        }else{
            print("Same as current app icon.")
        }
    }
    
    //This method wont show an alert while setting the app icon (Not safe, might crash if the Apple changes the method)
    private func setAppIconWithoutAlert(_ iconName: String?){
        if UIApplication.shared.responds(to: #selector(getter: UIApplication.supportsAlternateIcons)) && UIApplication.shared.supportsAlternateIcons{
            typealias setAlternateIconName = @convention(c) (NSObject, Selector, NSString?, @escaping (NSError) -> ()) -> ()
            let selectorString = "_setAlternateIconName:completionHandler:"
            let selector = NSSelectorFromString(selectorString)
            let imp = UIApplication.shared.method(for: selector)
            let method = unsafeBitCast(imp, to: setAlternateIconName.self)
            method(UIApplication.shared, selector, iconName as NSString?, { _ in })
        }
    }
    
    //Recommended approch but will show an Alert to the user.
    private func setAppIconWithAlert(_ iconName: String?){
        guard UIApplication.shared.supportsAlternateIcons else { return }
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if error == nil{
                print("The app icon has been successfully set.")
            }else{
                print("Could not set app icon due to error: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
}

//MARK: Dynamic app icon with Firebase remote config.
/*
extension AppIconManager {

    private let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      return formatter
    }()

    private let ICONKEY = "alternate_icon"
    
    func fetchIconConfigurationData(){
        let remoteConfig = RemoteConfig.remoteConfig()
        
        let remoteConfigSettings = RemoteConfigSettings()
        remoteConfigSettings.minimumFetchInterval = 0 //For debug
        remoteConfig.configSettings = remoteConfigSettings
        
        remoteConfig.fetch { [weak self] (status, error) in
            guard let self = self else { return }
            if status == .success {
                remoteConfig.activate { [weak self] _, _ in
                    guard let jsonObject = remoteConfig[self.ICONKEY].jsonValue else { return }
                    guard let data = try? JSONSerialization.data(withJSONObject: jsonObject),
                          let iconModel = try? JSONDecoder().decode(IconModel.self, from: data) else {
                        print("Error parsing remote config data to IconModel.")
                        return
                    }
                    DispatchQueue.main.async {
                        self?.validateIconModel(iconModel)
                    }
                }
            }else{
                print("Error fetching remote config: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    private func validateIconModel(_ model: IconModel){
        let currentDateString = dateFormatter.string(from: Date())
        if let startDate = dateFormatter.date(from: model.startDate),
           let endDate = dateFormatter.date(from: model.endDate),
           let currentDate = dateFormatter.date(from: currentDateString),
           currentDate >= startDate && currentDate <= endDate { // Check if the currentDate lies in between start_date and end_date
            self.setAppIcon(model.appIcon)
        }else{
            if currentAppIcon != nil{ // Set the default App icon
                self.setAppIcon(nil)
            }
        }
    }
    
}

//MARK: Firebase Remote Config JSON Model

struct IconModel: Codable {
    var startDate: String
    var endDate: String
    var appIcon: String
    
    enum CodingKeys: String, CodingKey{
        case startDate = "start_date"
        case endDate = "end_date"
        case appIcon = "app_icon"
    }
}

Sample JSON data
{"start_date":"2023-11-20","end_date":"2023-11-23","app_icon":"AnotherAppIcon"}

*/
