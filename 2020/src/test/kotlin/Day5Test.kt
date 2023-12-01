import kotlin.test.Test
import kotlin.test.assertEquals

class Day5Test {
    @Test
    fun `starts with rows of 0 to 127 and columns of 0 to 7 by default`() {
        val pass = BoardingPass()
        assertEquals(0..127, pass.rows)
        assertEquals(0..7, pass.columns)
    }

    @Test
    fun `can start with any rows or columns if you like`() {
        val pass = BoardingPass("", 1..2, 42..87)
        assertEquals(1..2, pass.rows)
        assertEquals(42..87, pass.columns)
    }

    @Test
    fun `can pick the next rows for characters F and B`() {
        val pass = BoardingPass()
        assertEquals(0..63, pass.nextRowForChar('F'), "pick the lower half for an F")
        assertEquals(64..127, pass.nextRowForChar('B'), "pick the upper half for a B")
    }

    @Test
    fun `the next rows depend on the current row range`() {
        val pass = BoardingPass("", 0..5)
        assertEquals(0..2, pass.nextRowForChar('F'), "pick the lower half for an F")
        assertEquals(3..5, pass.nextRowForChar('B'), "pick the upper half for a B")

        assertEquals(32..63, BoardingPass("", 0..63).nextRowForChar('B'), "pick the upper half for a B")
        assertEquals(32..47, BoardingPass("", 32..63).nextRowForChar('F'))

        assertEquals(40..47, BoardingPass("", 32..47).nextRowForChar('B'))

        val superSmallRange = BoardingPass("", 44..45)
        assertEquals(
            44..44,
            superSmallRange.nextRowForChar('F'),
            "for the final pick, the range is only one character deep"
        )
        assertEquals(
            45..45,
            superSmallRange.nextRowForChar('B'),
            "for the final pick, the range is only one character deep"
        )
    }

    @Test
    fun `can pick the next columns for characters L and R`() {
        val pass = BoardingPass()
        assertEquals(0..3, pass.nextColumnForChar('L'), "pick the lower half for an L")
        assertEquals(4..7, pass.nextColumnForChar('R'), "pick the upper half for a R")
    }

    @Test
    fun `finds the final row`() {
        assertEquals(44, BoardingPass("FBFBBFFRLR").findRow())
        assertEquals(44, BoardingPass("FBFBBFFRLR").findRow(), "will find the same row if called multiple times")
    }

    @Test
    fun `finds the final column`() {
        assertEquals(5, BoardingPass("FBFBBFFRLR").findColumn())
        assertEquals(5, BoardingPass("FBFBBFFRLR").findColumn(), "will find the same row if called multiple times")
    }

    @Test
    fun `finds the correct seat id`() {
        assertEquals(357, BoardingPass("FBFBBFFRLR").determineSeatId())
        assertEquals(567, BoardingPass("BFFFBBFRRR").determineSeatId())
        assertEquals(119, BoardingPass("FFFBBBFRRR").determineSeatId())
        assertEquals(820, BoardingPass("BBFFBBFRLL").determineSeatId())
    }
}