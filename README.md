## Story Telling

### Object:
#### Story.swift
```
import Foundation

var appAllowPartialCorrect = false

/// The object which hold a complete story
struct Story: Identifiable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case content
        case coverImage
        case backgroundImage
        case lang
    }
    
    enum BuildInStory {
        case threelittlepigs
    }
    
    var id = UUID()
    var name: String
    var content: String
    var coverImage: String
    var backgroundImage: String
    var lang: String
    
    var contents = [StoryFragment]()
    var pointer: Int = 0
    
    var currentFragment: StoryFragment { self.contents[pointer] }
    
    init(name: String, content: String, coverImage: String, backgroundImage: String, lang: String) {
        self.name = name
        self.content = content
        self.coverImage = coverImage
        self.backgroundImage = backgroundImage
        self.lang = lang
        
        self.setup()
    }

    mutating func setup() {
        self.contents.removeAll()
        let fragments = content.components(separatedBy: "-")
        for fragment in fragments {
            var fragment = StoryFragment(content: fragment)
            fragment.tokenize()
            self.contents.append(fragment)
        }
        print("word count: \(self.content.count)")

    }
    
    mutating func skip() {
        self.contents[pointer].skip()
    }
    
    mutating func check(recognizedString : String) {
        if !(currentFragment.isCompleted) {
            self.contents[pointer].check(recognizedString: recognizedString, allowPartialCorrect:  appAllowPartialCorrect)
        }
    }
}

```

#### Sample Use of Story
```

static func defaultStory(title: Story.BuildInStory) -> Story {
    switch(title) {
    case .threelittlepigs:
        let content =
        "從前有三隻小豬-豬大哥既貪睡又懶惰，豬二哥很愛吃-豬小弟是一個勤勞的好孩子-三隻小豬離開自己的家，在外面蓋房子-豬大哥用了最快的時間蓋了一座稻草屋-豬二哥隨後用木頭蓋了一座木屋-豬小弟為了蓋一間紅磚屋-他花了一天時間在辛勤的搬運石頭-天黑了，一隻飢餓的野狼出現了-三隻小豬聽到狼叫後-都害怕的躲進了自己的屋子裏-野狼來到了豬大哥的房子前面-牠深深的吸了一口氣，一口氣就把大哥的房子吹倒了-豬大哥慌忙的逃到豬二哥的房子裏-於是，野狼追着來到了豬二哥的房子前-野狼拿起了房子前面的火把，把豬二哥的房子一把火燒了-豬大哥帶着豬二哥逃進了豬小弟的房子-野狼來到豬小弟的房子前面-但這次不管野狼怎麼做，豬小弟的房子都很堅固-野狼見狀，只好失望的回到着林去了"
        var story = Story(name: "The Three Little Pigs", content: content, coverImage: "s1", backgroundImage: "Artboard 53", lang: "zh-hk")
        
        return story
    }
}

```

### Functions for fetching data:

#### Database.swift
```
private var storyRef: CollectionReference {
    db.collection("stories")
}

func documentStoryAddListener(completion: @escaping ([Story]) -> Void) -> ListenerRegistration {
    return storyRef.addSnapshotListener { querySnapshot, error in
        if let error = error {
            print("Error fetching documents: \(error.localizedDescription)")
            return
        }

        guard let documents = querySnapshot?.documents else {
            print("No documents")
            return
        }

        let stories = documents.compactMap { queryDocumentSnapshot -> Story? in
            return try? queryDocumentSnapshot.data(as: Story.self)
        }
        completion(stories)
    }
}

```

### File Structure in Firestore

![image](https://github.com/user-attachments/assets/e4d9e372-8319-46dd-aed0-6ceae3dabea2)


## Shopping System

### Object:

#### Shop.swift
```
struct Shop: Identifiable, Codable {
    @DocumentID var id: String?
    var itemName: String
    var price: Int
    
    init(itemName: String, price: Int) {
        self.itemName = itemName
        self.price = price
    }
}

```

### Functions for fetching data:

#### Database.swift

```
private var shopRef: CollectionReference {
    db.collection("shopItems")
}

func documentShopAddListener(completion: @escaping ([Shop]) -> Void) -> ListenerRegistration {
    return shopRef.addSnapshotListener { querySnapshot, error in
        if let error = error {
            print("Error fetching documents: \(error.localizedDescription)")
            return
        }

        guard let documents = querySnapshot?.documents else {
            print("No documents")
            return
        }

        let shops = documents.compactMap { queryDocumentSnapshot -> Shop? in
            return try? queryDocumentSnapshot.data(as: Shop.self)
        }
        
        print("got shops: \(shops.count)")
        
        completion(shops)
    }
}

```

#### DataManager.swift

```

import Foundation

class DataManager: ObservableObject {
    static let shared = DataManager()

    @Published var userData: UserData {
        didSet {
            saveUserData()
        }
    }

    private let tokenKey = "TokenKey"
    private let purchaseItemsKey = "PurchaseItemsKey"

    private init() {
        let token = UserDefaults.standard.integer(forKey: tokenKey)
        let purchasedItems = UserDefaults.standard.stringArray(forKey: purchaseItemsKey) ?? []
        self.userData = UserData(token: token == 0 ? 100 : token, purchasedItems: purchasedItems)
    }

    private func saveUserData() {
        UserDefaults.standard.set(userData.token, forKey: tokenKey)
        UserDefaults.standard.set(userData.purchasedItems, forKey: purchaseItemsKey)
    }
    
    func addToken(token: Int) {
        userData.token += token
        saveUserData()
    }
    
    func purchaseItem(item: Shop) {
        userData.purchasedItems.append(item.itemName)
        userData.token -= item.price
        saveUserData()
    }
}

```

### File Structure in Firestore

![image](https://github.com/user-attachments/assets/e720d623-9cda-40c1-bf7b-ddfabd4a3694)




