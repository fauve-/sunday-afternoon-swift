
extension String{
    //whelp, both
    //stringByReplacingCharactersInRange
    //stringByReplacingOccurrencesOfString
    //seem to be busted, so we're going to do it the old fashioned (or at least highly inefficient) way
    //the reason it's not so clean is that we need lookahead
    //I'm probably missing something obvious
    func replace(replace:String, newString:String)->String{
        var s  = String()
        for var idx = self.characters.startIndex; idx != self.characters.endIndex;idx = idx.successor(){
            if self[idx] == replace[replace.startIndex]{
                //we matched!
                let begIdx = idx
                var matched = true
                var walkingIdx = idx.successor()
                for var j = replace.startIndex.successor();j != replace.endIndex; j = j.successor(){
                    if self[walkingIdx] != replace[j]{
                        matched = false
                        break
                    }
                    walkingIdx = walkingIdx.successor()
                }
                if matched{
                    //matched string
                    s.appendContentsOf(newString)
                    if replace.characters.count == 1{
                        idx = begIdx.successor()
                    }else{
                        idx = begIdx.advancedBy(replace.characters.count - 1)
                    }
                }else{
                    //rewalk to copy
                    for var j = begIdx;j != walkingIdx;j = j.successor(){
                        s.append(self[j])
                    }
                    idx = walkingIdx
                }
            }else{
                s.append(self[idx])
            }
        }
        return s
    }        

}
