package commons_lang4cj.test.reflect

import std.unittest.*
import std.unittest.testmacro.*
import std.reflect.*
import commons_lang4cj.reflect.*

public open class A {}
public open class B <: A {}
public class C <: B {}

@Test
class InheritanceUtilsTest {
    @TestCase
    func testDistance() {
        let aName = TypeInfo.of(A()).qualifiedName
        let bName = TypeInfo.of(B()).qualifiedName
        let c = C()
        @Expect(InheritanceUtils.distance(c, bName), 1)
        @Expect(InheritanceUtils.distance(c, aName), 2)
        @Expect(InheritanceUtils.isSubclassOf(c, aName), true)
    }
}

