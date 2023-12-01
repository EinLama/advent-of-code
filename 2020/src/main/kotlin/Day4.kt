import java.io.File
import java.util.*
import kotlin.collections.ArrayList

open class Passport(private val input: String) {
    private val requiredFields = listOf("byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid")
    protected var attributes: List<IAttribute> = ArrayList()

    fun parse(): Passport {
        val attributes = input.split(' ', '\n').filter(String::isNotEmpty)
        this.attributes = attributes.map { a -> val s = a.split(':'); AttributeFactory.createInstance(s[0], s[1]) }

        return this
    }

    open fun isValid(): Boolean {
        requiredFields.forEach { f ->
            if (attributes.none { a -> a.name() == f }) {
                return false
            }
        }
        return true
    }
}

class PassportPart2(input: String) : Passport(input) {
    override fun isValid(): Boolean {
        if (!super.isValid()) {
            return false
        }

        return attributes.all(IAttribute::isValid)
    }
}


open class Day4 {
    protected fun collectEntries(str: String): ArrayList<String> {
        val entries = ArrayList<String>()
        var sb = StringBuilder()
        str.lines().forEach { line ->
            if (line.isEmpty()) {
                entries.add(sb.toString())
                sb = StringBuilder()
            } else {
                sb.append("\n")
                sb.append(line)
            }
        }
        entries.add(sb.toString())

        return entries
    }

    open fun solve(): Int {
        val inputString = getRealInput()
        val entries = collectEntries(inputString)

        return entries.count { e -> Passport(e).parse().isValid() }
    }

    fun getRealInput(): String {
        return javaClass.getResource("input_files/day4").readText()
    }

    fun getTestInput(): String {
        return """
            ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
            byr:1937 iyr:2017 cid:147 hgt:183cm

            iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
            hcl:#cfa07d byr:1929

            hcl:#ae17e1 iyr:2013
            eyr:2024
            ecl:brn pid:760753108 byr:1931
            hgt:179cm

            hcl:#cfa07d eyr:2025 pid:166559648
            iyr:2011 ecl:brn hgt:59in
        """.trimIndent()
    }
}

class Day4Part2 : Day4() {
    override fun solve(): Int {
        val inputString = getRealInput()
        val entries = collectEntries(inputString)

        return entries.count { e -> PassportPart2(e).parse().isValid() }
    }

    fun getInvalidTestInput(): String {
        return """
            eyr:1972 cid:100
            hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

            iyr:2019
            hcl:#602927 eyr:1967 hgt:170cm
            ecl:grn pid:012533040 byr:1946

            hcl:dab227 iyr:2012
            ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

            hgt:59cm ecl:zzz
            eyr:2038 hcl:74454a iyr:2023
            pid:3556412378 byr:2007
        """.trimIndent()
    }

    fun getValidTestInput(): String {
        return """
            pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
            hcl:#623a2f

            eyr:2029 ecl:blu cid:129 byr:1989
            iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

            hcl:#888785
            hgt:164cm byr:2001 iyr:2015 cid:88
            pid:545766238 ecl:hzl
            eyr:2022

            iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
        """.trimIndent()
    }
}

