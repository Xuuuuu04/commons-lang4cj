import std.regex.*

main() {
    println("=== Testing Regex.findAll ===")
    let input = "A &#65; B"
    let pattern = Regex(#"&#(\d+);"#)
    let iterator = pattern.findAll(input)
    var count = 0
    for (m in iterator) {
        count++
        println("Match ${count}: ${m.matchString()}")
        let pos = m.matchPosition(0)
        println("Start: ${pos.start}, End: ${pos.end}")
        println("Group 1: ${m.matchString(1)}")
    }
}
