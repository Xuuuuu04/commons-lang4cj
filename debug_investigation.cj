import std.regex.*
import commons_lang4cj.utils.*

main() {
    println("=== Testing Regex.findAll ===")
    let input = "&#65;"
    let pattern = Regex(#"&#(\d+);"#)
    let iterator = pattern.findAll(input)
    var count = 0
    for (m in iterator) {
        count++
        println("Match found: ${m.matchString()}")
        println("Group 1: ${m.matchString(1)}")
        println("Start: ${m.matchPosition(0).start}")
        println("End: ${m.matchPosition(0).end}")
    }
    println("Matches count: ${count}")

    println("\n=== Testing StringUtils.abbreviate exception ===")
    try {
        StringUtils.abbreviate("abc", 3)
    } catch (e: IllegalArgumentException) {
        println("Caught IllegalArgumentException: ${e.message}")
    } catch (e: Exception) {
        println("Caught OTHER Exception: ${e.toString()}")
    }
}
