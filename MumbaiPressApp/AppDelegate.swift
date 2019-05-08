

import UIKit
import CoreData
import UserNotifications
import Firebase
import FirebaseMessaging
import GoogleMobileAds


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate
{

    var window: UIWindow?
     var NotificationCnt = Int(0)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().remoteMessageDelegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
        FirebaseApp.configure()
        NotificationCnt = 0
       // GADMobileAds.sharedInstance().start(completionHandler: nil)
    
        GADMobileAds.configure(withApplicationID: "ca-app-pub-5349935640076581~9403054717")
        
        return true
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }


    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String)
    {
        print("Firebase registration token: \(fcmToken)")
       
    }
    
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
            if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
                
                if Messaging.messaging().fcmToken != nil
                {
                    Messaging.messaging().subscribe(toTopic: "english_newsios")
                    
                    Messaging.messaging().unsubscribe(fromTopic: "english_news")
                    
                }
          
        }
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let userInfo = notification.request.content.userInfo
        
        print(userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let navigationController = self.window?.rootViewController as! UINavigationController
        
        let userInfo = response.notification.request.content.userInfo
        
        print(userInfo)
     
        var newsArr = [DetaileNews]()
        
        guard
            
            let aps = userInfo[AnyHashable("aps")] as? NSDictionary,
            let alert = aps["alert"] as? NSDictionary,
            let title = alert["title"] as? String,
          //  let msg = alert["body"] as? String,
            let msg = (userInfo[AnyHashable("gcm.notification.message")] as? String),
            
            let date = (userInfo[AnyHashable("gcm.notification.date")] as? String),
            let img = userInfo[AnyHashable("gcm.notification.url")] as? String

        else {
                // handle any error here
                return
        }
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if msg == "Announcement"
        {
            let VC = storyboard.instantiateViewController(withIdentifier: "UpdatesNewsVC") as! UpdatesNewsVC
            VC.StrUpdate = title
            navigationController.pushViewController(VC, animated: true)
            
        }else{
            
            let lcDetaileNews = DetaileNews(date: date, title: title, url: img, DetailsDesc: msg, nIndex: 0, link: "")
            newsArr.append(lcDetaileNews)
            
            
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailNewsScrollVC") as! DetailNewsScrollVC
            
            vc.setImageToView(newsarr: newsArr, nSelectedIndex: 0, nTotalNews: 1)
            
            navigationController.pushViewController(vc, animated: true)
        }
        
    }
    
    func application(received remoteMessage: MessagingRemoteMessage)
    {
        print(remoteMessage.appData)
        
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
      
        // Print full message.
        print("message recived")
        NotificationCnt = NotificationCnt + 1
        UIApplication.shared.applicationIconBadgeNumber = NotificationCnt
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func instance() ->  AppDelegate{
        
        return AppDelegate()
    }
    
    
    func applicationWillResignActive(_ application: UIApplication)
    {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
       NotificationCnt = NotificationCnt + 1
    }

    func applicationWillEnterForeground(_ application: UIApplication)
    {
        UIApplication.shared.applicationIconBadgeNumber = 0
        NotificationCnt = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        UIApplication.shared.applicationIconBadgeNumber = 0
        NotificationCnt = 0
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
      self.saveContext()
    }

// MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "MumbaiPressApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
            
             
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

// MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

