
import UIKit

class EmojiHistory {
    
    var current:Int = -1;
    var max:Int = -1;
    
    //var emo:[Int:(x:CGFloat, y:CGFloat, scl:CGFloat, emoji:Int)]?;
    //var emo : [(x:CGFloat, y:CGFloat, scl:CGFloat, emoji:Int)] = [];
    var emo: [[(x:CGFloat, y:CGFloat, scl:CGFloat, emoji:CGImage)]] = []
    
    init(){
        
    }
    
    func nextTap(_ x:CGFloat, y:CGFloat, scl:CGFloat, emoji:CGImage){
        //current = max;
        let cur = current;
        for i in 0 ..< (cur-max){
            print("minus = \(current)");
            current -= 1;
            emo.removeLast();
        }
        
        current += 1;
        max = current;
        
        let ar = [(x:CGFloat, y:CGFloat, scl:CGFloat, emoji:CGImage)]();
        emo.append(ar);
        addEmoji(x, y: y, scl: scl, emoji: emoji);
        
    }
    
    func addEmoji(_ x:CGFloat, y:CGFloat, scl:CGFloat, emoji:CGImage){
        emo[current].append(x:x, y:y, scl:scl, emoji:emoji);
    }
    
    func newDrawing(){
        current = -1;
        max = -1;
        emo.removeAll();
    }
    
    func undo(_ dv:DrawView){
        
        if(max>=0){
            max -= 1;
        }
        
        redraw(dv);
        
    }
    func redo(_ dv:DrawView){
        
        if(max < current){
            max += 1
        }
        
        redraw(dv);
        
    }
    
    
    
    func redraw(_ dv:DrawView){
        
        
        
        for i in 0 ..< emo.count{
            for k in 0 ..< emo[i].count{
                
                if(i<=max){
                    
                    let x = emo[i][k].x;
                    let y = emo[i][k].y;
                    let scl = emo[i][k].scl;
                    let emoji = emo[i][k].emoji;
                    
                    dv.drawToCache(x, y: y, scl: scl, emoji: emoji)
                    
                }
                
            }
            
        }
        
    }
    
    
    
}
