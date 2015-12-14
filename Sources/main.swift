//so we're going to implement http://rosettacode.org/wiki/Globally_replace_text_in_several_files
//invoked like so `./fnr "my sweet text" file1 file2 file3 file4
//if those files are directories, we'll ignore them
//pretty much it

//it's a little weird not having an entrypoint function
//wonder how large programs do the whole
//int main(){
//init_state()
//main_loop()
//}
//idiom that is so common
//my it's my server-side background talking

//import glibc for exit etc
import Glibc

//let's go ahead and look at our arguments
//TODO: guards!
if Process.arguments.count < 3 {
    print("Invoke like this \(Process.arguments[0]) <old string> <new string> <some files...>")
    exit(-1)
}
//okay, now we need to do some real work I guess
//we have to revert back to c stuff to open some files

let toReplace = Process.arguments[1]
let newString = Process.arguments[2]

//remove the cruft
var filesToScan = Array<String>.init(Process.arguments)
filesToScan.removeFirst(3)
                        
                        
for filename in filesToScan {
    //some dog and pony show to open up this pit
    let  UnsafeFileName = [UInt8](filename.utf8)
    var unsafeFilePointer = UnsafeMutablePointer<Int8>(UnsafeFileName)
    let fp = fopen(unsafeFilePointer,"r+")
    let BUFSIZE = 1024
    var buf = [CChar](count:BUFSIZE, repeatedValue:CChar(0))
    fread(&buf,Int(1),Int(BUFSIZE),fp)
    fclose(fp)
    
    //let us now do some things
    let contents = String.fromCString(buf)!
    let newContents = contents.replace(toReplace,newString:newString)
    let UnsafeNewContents = [UInt8](newContents.utf8)

    //reopen file to get a new FILE* that will allow us to tuncate if the file lengths are different
    let newfp = fopen(unsafeFilePointer,"w")
    fwrite(UnsafeNewContents,Int(1),UnsafeNewContents.count,newfp);
    fflush(newfp)
    fclose(newfp)
}

