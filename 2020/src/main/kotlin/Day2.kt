import java.io.File

interface PasswordWithRule {
    fun isFollowing(rule: Rule): Boolean
    fun applyRule(rule: Rule): PasswordWithRule
    fun isValid(): Boolean
}

open class Password(open val password: String) : PasswordWithRule {
    private var isValid: Boolean = false

    override fun isFollowing(rule: Rule): Boolean {
        val occurrences = password.count { char -> char == rule.char }
        //println("occurrence of $rule in $this: $occurrences")
        return occurrences >= rule.min && occurrences <= rule.max
    }

    override fun applyRule(rule: Rule): PasswordWithRule {
        if (isFollowing(rule)) {
            isValid = true
        }

        return this
    }

    override fun isValid(): Boolean {
        return isValid
    }
}

data class PasswordForPart2(override val password: String) : Password(password) {
    override fun isFollowing(rule: Rule): Boolean {
        var occurrences = 0

        if (password.length > rule.min - 1 && password[rule.min - 1] == rule.char)
            occurrences++
        if (password.length > rule.max - 1 && password[rule.max - 1] == rule.char)
            occurrences++

        // println("Number for occurrences in $password with $rule: $occurrences")
        return occurrences == 1
    }
}

data class Rule(val min: Int, val max: Int, val char: Char) {
}

class PasswordAndRuleParser {
    private lateinit var password: String
    private lateinit var rule: Rule

    constructor() {
    }

    constructor(input: String) {
        parse(input)
    }

    fun parse(input: String) {
        val inputChunks = splitInput(input)
        rule = Rule(inputChunks[0].toInt(), inputChunks[1].toInt(), inputChunks[2].toCharArray()[0])
        password = inputChunks[3]
    }

    fun getPassword(): String {
        return password
    }

    fun getRule(): Rule {
        return rule
    }

    private fun splitInput(input: String): List<String> {
        return input.trim().split("-", " ", ": ")
    }
}

open class Day2 {
    private fun readFile(): String {
        return javaClass.getResource("input_files/day2").readText()
    }

    protected fun readTestString(): String {
        return """
        1-3 a: abcde
        1-3 b: cdefg
        2-9 c: ccccccccc
        """
    }

    fun solve(): Int {
        val input = readFile()
        var passwords: ArrayList<PasswordWithRule> = ArrayList()
        input.lines().forEach { line ->
            if (line.isNotBlank()) {
                val parser = PasswordAndRuleParser(line)
                val password = getPasswordFromParser(parser)
                val rule = parser.getRule()

                passwords.add(password.applyRule(rule))
            }
        }

        return passwords.count { p -> p.isValid() }
    }

    open fun getPasswordFromParser(parser: PasswordAndRuleParser): PasswordWithRule {
        return Password(parser.getPassword())
    }
}

class Day2Part2 : Day2() {
    override fun getPasswordFromParser(parser: PasswordAndRuleParser): PasswordWithRule {
        return PasswordForPart2(parser.getPassword())
    }
}