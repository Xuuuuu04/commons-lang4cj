package commons_lang4cj.test.reflect

import std.unittest.*
import std.unittest.testmacro.*
import commons_lang4cj.reflect.ClassUtils

@Test
public class ClassUtilsTest {

    @TestCase
    public func testGetShortClassNameString() {
        @Expect(ClassUtils.getShortClassName("java.lang.String"), "String")
        @Expect(ClassUtils.getShortClassName("String"), "String")
        @Expect(ClassUtils.getShortClassName("java.util.Map$Entry"), "Entry")
        @Expect(ClassUtils.getShortClassName(""), "")
    }

    @TestCase
    public func testGetPackageNameString() {
        @Expect(ClassUtils.getPackageName("java.lang.String"), "java.lang")
        @Expect(ClassUtils.getPackageName("String"), "")
        @Expect(ClassUtils.getPackageName("java.util.Map$Entry"), "java.util")
    }
}
