//
//  Packs.swift
//  emojiinktest
//
//  Created by Vince McKelvie on 3/11/15.
//  Copyright (c) 2015 BetterMagic. All rights reserved.
//

import Foundation

class Packs{
    
    var emojiDIR = ["/emoji/colors/", "/emoji/skin/0/", "/emoji/flags/"]
    
    var textDict:[String:String] = [
        "100 Pack":"💯",
        "Animals Pack":"😺,😻,😽,😼,🙀,😿,😹,😾,🙈,🙉,🙊,🐶,🐺,🐱,🐭,🐹,🐰,🐸,🐯,🐨,🐻,🐷,🐽,🐮,🐗,🐵,🐒,🐴,🐑,🐘,🐼,🐧,🐦,🐤,🐥,🐣,🐔,🐍,🐢,🐛,🐝,🐜,🐞,🐌,🐙,🐚,🐠,🐟,🐬,🐳,🐋,🐄,🐏,🐀,🐃,🐅,🐇,🐉,🐎,🐐,🐓,🐕,🐖,🐁,🐂,🐲,🐡,🐊,🐫,🐪,🐆,🐈, and 🐩",
        "Flags Pack":"🇯🇵,🇰🇷,🇩🇪,🇨🇳,🇺🇸,🇫🇷,🇪🇸,🇮🇹,🇷🇺, and 🇬🇧",
        "Fruit Pack":"🍎,🍏,🍊,🍋,🍒,🍇,🍉,🍓,🍑,🍈,🍌,🌽,🍅,🍆,🍠,🍍, and 🍐",
        
        "Hearts Pack":"💛,💙,💜,💚,❤️,💔,💗, 💝, 💓,💕,💖,💞,💘,💟, and ♥️",
        "Pictures Pack":"🌇,🌆,🌄,🗻,🗾,🗼,🏭,⛺️,🏰,🏯,🚢,🌅,🌃,🗽,🌉,🎠,🎡,⛲️, and 🎢",
        "Sports Pack":"🎳,🏉,🎱,🎾,⚾️,⚽️,🏀,🏈,🎮,🎲,🎯,🚵,🚴,⛳️,🏇,🏆,🎿,🏂,🏁,🏄, and 🏊",
        "Vehicles Pack":"🚀,✈️,🚅,🚄,🚆,🚞,🚉,🚊,🚂,🚁,⛵️,🚤,🚈,🚇,🚝,🚋,🚃,🚎,🚌,🚍,🚟,🚚,🚲,🚛,🚐,🚖,🚕,🚑,🚒,🚗,🚘,🚔,🚓,🚙, and 🚜"
    ];
    var numbersDict:[String:[Int]] = [
        "100 Pack":[44],
        "Animals Pack":[393,395,396,398,397,401,400,394,399,554,555,556,468,470,316,769,469,771,266,315,623,546,89,90,770,543,545,542,544,764,685,772,687,686,313,314,312,766,262,264,263,311,586,32,462,113,767,282,182,235,183,181,684,763,683,622,421,848,260,539,849,765,463,464,847,459,265,465,261,467,466,460,461,768],
        "Flags Pack":[81,743,406,10,11,127,407,241,129,128],
        "Fruit Pack":[21,255,414,303,23,73,20,24,22,279,304,302,19,131,532,305,280],
        "Hearts Pack":[318,188,141,268,5,41,105, 107, 102,103,104,108,106,79,4],
        "Pictures Pack":[411,410,130,204,207,206,178,153,180,179,218,409,158,206,160,171,172,152,173],
        "Sports Pack":[621,457,583,281,661,660,420,540,582,759,30,525,237,240,539,456,232,760,676,233,234],
        "Vehicles Pack":[53,745,210,209,211,720,639,640,55,54,405,523,212,638,216,520,519,213,521,522,403,402,222,236,716,326,325,717,56,57,214,719,718,215,327]
    ];
    
    var payAll:[Int] =
[44,393,395,396,398,397,401,400,394,399,554,555,556,468,470,316,769,469,771,266,315,623,546,89,90,770,543,545,542,544,764,685,772,687,686,313,314,312,766,262,264,263,311,586,32,462,113,767,282,182,235,183,181,684,763,683,622,421,848,260,539,849,765,463,464,847,459,265,465,261,467,466,460,461,768,81,743,406,10,11,127,407,241,129,128,21,255,414,303,23,73,20,24,22,279,304,302,19,131,532,305,280,318,188,141,268,5,41,105,107,102,103,104,108,106,79,4,411,410,130,204,207,206,178,153,180,179,218,409,158,206,160,171,172,152,173,621,457,583,281,661,660,420,540,582,759,30,525,237,240,539,456,232,760,676,233,234,53,745,210,209,211,720,639,640,55,54,405,523,212,638,216,520,519,213,521,522,403,402,222,236,716,326,325,717,56,57,214,719,718,215,327];
    

    //var packsPurchased:[String:Bool] = ["100 Pack":false, "Animals Pack":false, "Flags Pack":false, "Fruit Pack":false, "Hearts Pack":false, "Pictures Pack":false, "Sports Pack":false, "Vehicles Pack":false];
    var packsPurchased:[String:Bool] = ["100 Pack":false, "Animals Pack":false, "Flags Pack":false, "Fruit Pack":false, "Hearts Pack":false, "Pictures Pack":false, "Sports Pack":false, "Vehicles Pack":false];
    
    func isPack(_ i:Int) -> Bool {
        for k in 0 ..< payAll.count{
            if( i == payAll[k]){
                return true;
            }
        }
        return false;
    }
    
    func checkPack(_ i:Int) -> String {
        var str = "";
        for (pack, numbers) in numbersDict {
            for number in numbers {
                if(i == number ){
                    str = String(pack);
                }
            }
        }
        return str;
    }
    
    func getEmojis(_ str:String) -> String{
        let s:String = textDict[str]!;
        return s;
    }
    
    func setBools(_ bs:[String:Bool]){
        for (pack, _) in packsPurchased {
            packsPurchased[pack] = bs[pack];
        }
    }
    
    func isPackPurchased(_ i:Int) -> Bool{
        let pack = self.checkPack(i);
        let isPurchased = self.packsPurchased[pack];
        return isPurchased!;
    }
   
    //func unlockProduct(str:String) -> [String:Bool]{
        //println("unlockProduct str = \(str)");
        //packsPurchased[str] = true;
        //return packsPurchased;
    //}
    
    func isInPack(_ i:Int) -> Bool {
        for (_, numbers) in numbersDict {
            for number in numbers {
                if(i == number ){
                    return true;
                }
            }
        }
        return false;
    }
    
    func getPacksPurchased() -> [String:Bool]{
        return packsPurchased;
    }

    //var pacDict
    //init(){
        //name = "John Doe"
        //score = 0
    //}
}
