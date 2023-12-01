import java.lang.IllegalArgumentException

class BoardingPass(private val pass: String = "", var rows: IntRange = 0..127, var columns: IntRange = 0..7) {
    fun determineSeatId(): Int {
        return findRow() * 8 + findColumn()
    }

    fun findRow(): Int {
        if (hasFoundRow()) {
            return rows.first
        }

        repeat(7) {
            rows = nextRowForChar(pass[it])
        }

        return rows.first;
    }

    fun findColumn(): Int {
        if (hasFoundColumn()) {
            return columns.first
        }

        repeat(3) {
            columns = nextColumnForChar(pass[7 + it])
        }

        return columns.first;
    }

    private fun hasFoundRow(): Boolean {
        return rows.count() == 1
    }

    private fun hasFoundColumn(): Boolean {
        return columns.count() == 1
    }

    fun nextRowForChar(c: Char): IntRange {
        return when (c) {
            'F' ->
                lowerHalf(rows)
            'B' ->
                upperHalf(rows)
            else ->
                throw IllegalArgumentException("Cannot deal with this character: $c")
        }
    }

    fun nextColumnForChar(c: Char): IntRange {
        return when (c) {
            'L' ->
                lowerHalf(columns)
            'R' ->
                upperHalf(columns)
            else ->
                throw IllegalArgumentException("Cannot deal with this character: $c")
        }
    }

    private fun upperHalf(range: IntRange): IntRange {
        if (range.count() == 2) {
            return range.last..range.last
        }

        return ((range.last - range.first) / 2 + range.first + 1)..range.last
    }

    private fun lowerHalf(range: IntRange): IntRange {
        if (range.count() == 2) {
            return range.first..range.first
        }

        return range.first..(range.first + (range.last - range.first) / 2)
    }
}


class Day5 {
    fun solve(): Int {
        val lines = javaClass.getResource("input_files/day5").readText().lines()
        val highestId = lines.map { line -> BoardingPass(line).determineSeatId() }.maxOrNull()

        return highestId!!
    }
}