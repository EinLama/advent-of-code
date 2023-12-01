import java.io.File

data class Pair(val number: Int, val otherNumber: Int) {
    private fun sum(): Int {
        return number + otherNumber
    }

    fun isSolution(): Boolean {
        return sum() == 2020
    }

    fun getResult(): Int {
        return number * otherNumber
    }
}

open class Day1 {
    private lateinit var numbers: List<Int>

    fun solve(): Pair? {
        readFile()
        return findSolution()
    }

    private fun readFile() {
        numbers = javaClass.getResource("input_files/day1")
            .readText()
            .lines()
            .map(String::toInt)
    }

    protected open fun findSolution(): Pair? {
        numbers.forEach { n ->
            numbers.forEach { m ->
                val pair = Pair(n, m)
                if (pair.isSolution())
                    return pair
            }
        }

        return null
    }
}

class Day1Part2 {
    private lateinit var numbers: List<Int>

    fun solve(): Int {
        readFile()
        return findSolution()
    }

    private fun readFile() {
        numbers = javaClass.getResource("input_files/day1")
            .readText()
            .lines()
            .map(String::toInt)
    }

    private fun findSolution(): Int {
        numbers.forEach { n ->
            numbers.forEach { m ->
                numbers.forEach { k ->
                    if (n + m + k == 2020)
                        return n * m * k
                }
            }
        }

        return 0
    }
}