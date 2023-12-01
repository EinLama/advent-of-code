import java.io.File
import java.math.BigInteger

/**
 * This solution is far more complicated than it has to be.
 * Could've simply went for a for-loop.
 *
 * I wanted to be flexible for a complicated part two and make
 * visualization easier. In hindsight, that was completely unnecessary :O
 */

data class Position(val x: Int, val y: Int)

class Player {
    var currentPosition = Position(0, 0)

    fun moveRelative(x: Int, y: Int) {
        currentPosition = Position(currentPosition.x + x, currentPosition.y + y)
    }
}

open class Map {
    val player = Player()
    private var terrainWidth = 0
    private var terrainHeight = 0
    private val terrain = HashMap<Position, Char>()

    constructor(plainMap: String) {
        val mapAsLines = plainMap.lines()
        terrainHeight = mapAsLines.size

        for ((x, line) in mapAsLines.withIndex()) {
            line.withIndex().forEach {
                val pos = Position(x, it.index)
                terrain[pos] = it.value
            }

            if (terrainWidth == 0) {
                terrainWidth = line.length
            }
        }
    }

    fun markCurrentPlayerPosition() {
        if (terrain[player.currentPosition] == '.')
            terrain[player.currentPosition] = 'O'
        else if (terrain[player.currentPosition] == '#')
            terrain[player.currentPosition] = 'X'
    }

    fun hasPlayerStrolledToTheEast(): Boolean {
        return player.currentPosition.y >= terrainWidth
    }

    fun teleportPlayer() {
        player.moveRelative(0, -terrainWidth)
    }

    fun hasPlayerReachedEnd(): Boolean {
        return player.currentPosition.x > terrainHeight
    }

    override fun toString(): String {
        val s = StringBuilder()
        (0 until terrainHeight).forEach { x ->
            (0 until terrainWidth).forEach { y ->
                s.append(terrain[Position(x, y)])
            }
            s.append("\n")
        }

        return s.toString()
    }
}

class Game(private val map: Map, private val moveDown: Int, private val moveRight: Int) {
    fun run(print: Boolean = true) {
        if (print)
            println(map)
        map.markCurrentPlayerPosition()

        while (!map.hasPlayerReachedEnd()) {
            if (print)
                divider()

            map.player.moveRelative(moveDown, moveRight)
            if (map.hasPlayerStrolledToTheEast())
                map.teleportPlayer()
            map.markCurrentPlayerPosition()

            if (print)
                println(map)
        }
    }

    fun getNumberOfVisitedTrees(): BigInteger {
        val trees = map.toString().count { c -> c == 'X' }
        return trees.toBigInteger()
    }

    private fun divider() {
        println("------------------------------------------")
    }
}


open class Day3 {
    open fun solve(): BigInteger {
        val game = Game(Map(getRealMapInput()), 1, 3)
        game.run(false)

        return game.getNumberOfVisitedTrees()
    }

    protected fun getTestMapInput(): String {
        return """
            ..##.......
            #...#...#..
            .#....#..#.
            ..#.#...#.#
            .#...##..#.
            ..#.##.....
            .#.#.#....#
            .#........#
            #.##...#...
            #...##....#
            .#..#...#.#
        """.trimIndent()
    }

    protected fun getRealMapInput(): String {
        return javaClass.getResource("input_files/day3").readText().trim()
    }
}

class Day3Part2 : Day3() {
    override fun solve(): BigInteger {
        val movements = listOf(Position(1, 1),
                Position(3, 1),
                Position(5, 1),
                Position(7, 1),
                Position(1, 2))

        val treesFound = movements.map { pos ->
            val game = Game(Map(getRealMapInput()), pos.y, pos.x)
            game.run(false)
            game.getNumberOfVisitedTrees()
        }

        println(treesFound)
        return treesFound.reduce { acc, i -> acc * i }
    }
}