//
//  Story.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

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
    
    static var list = [Story]()
    
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

let stories = [
    Story.defaultStory(title: .threelittlepigs)
]

extension Story {
    static func defaultStory(title: Story.BuildInStory) -> Story {
        switch(title) {
        case .threelittlepigs:
            let content =
            "從前有三隻小豬-豬大哥既貪睡又懶惰，豬二哥很愛吃-豬小弟是一個勤勞的好孩子-三隻小豬離開自己的家，在外面蓋房子-豬大哥用了最快的時間蓋了一座稻草屋-豬二哥隨後用木頭蓋了一座木屋-豬小弟為了蓋一間紅磚屋-他花了一天時間在辛勤的搬運石頭-天黑了，一隻飢餓的野狼出現了-三隻小豬聽到狼叫後-都害怕的躲進了自己的屋子裏-野狼來到了豬大哥的房子前面-牠深深的吸了一口氣，一口氣就把大哥的房子吹倒了-豬大哥慌忙的逃到豬二哥的房子裏-於是，野狼追着來到了豬二哥的房子前-野狼拿起了房子前面的火把，把豬二哥的房子一把火燒了-豬大哥帶着豬二哥逃進了豬小弟的房子-野狼來到豬小弟的房子前面-但這次不管野狼怎麼做，豬小弟的房子都很堅固-野狼見狀，只好失望的回到着林去了"
            var story = Story(name: "The Three Little Pigs", content: content, coverImage: "s1", backgroundImage: "Artboard 53", lang: "zh-hk")
            
            return story
        }
    }
}
