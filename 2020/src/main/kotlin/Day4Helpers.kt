import java.lang.IllegalArgumentException

interface IAttribute {
    fun name(): String
    fun value(): String
    fun isValid(): Boolean
}

abstract class Attribute(val value: String) : IAttribute {
    override fun value(): String {
        return value
    }

    fun valueAsInt(): Int {
        return value.toInt()
    }
}

class AttributeFactory() {
    companion object {
        fun createInstance(name: String, value: String): IAttribute {
            when (name) {
                "byr" -> return BirthYear(value)
                "iyr" -> return IssueYear(value)
                "eyr" -> return ExpirationYear(value)
                "hgt" -> return Height(value)
                "hcl" -> return HairColor(value)
                "ecl" -> return EyeColor(value)
                "pid" -> return PassportId(value)
                "cid" -> return CountryId(value)
            }

            throw IllegalArgumentException("Need valid Attribute, got something else")
        }
    }
}


class CountryId(value: String) : Attribute(value) {
    override fun name(): String {
        return "cid"
    }

    override fun isValid(): Boolean {
        return true
    }
}

class PassportId(value: String) : Attribute(value) {
    override fun name(): String {
        return "pid"
    }

    override fun isValid(): Boolean {
        return "\\d{9}".toRegex().matches(value)
    }
}

class EyeColor(value: String) : Attribute(value) {
    override fun name(): String {
        return "ecl"
    }

    override fun isValid(): Boolean {
        return listOf("amb", "blu", "brn",
                "gry", "grn", "hzl", "oth").contains(value)
    }
}

class HairColor(value: String) : Attribute(value) {
    override fun name(): String {
        return "hcl"
    }

    override fun isValid(): Boolean {
        return "#[0-9a-f]{6}".toRegex().matches(value)
    }
}

class Height(value: String) : Attribute(value) {
    override fun name(): String {
        return "hgt"
    }

    override fun isValid(): Boolean {
        return when {
            value.endsWith("cm") -> {
                (150..193).contains(value.split("cm")[0].toInt())
            }
            value.endsWith("in") -> {
                (59..76).contains(value.split("in")[0].toInt())
            }
            else -> {
                false
            }
        }
    }
}

class ExpirationYear(value: String) : Attribute(value) {
    override fun name(): String {
        return "eyr"
    }

    override fun isValid(): Boolean {
        return (2020..2030).contains(valueAsInt())
    }
}

class BirthYear(value: String) : Attribute(value) {
    override fun name(): String {
        return "byr"
    }

    override fun isValid(): Boolean {
        return (1920..2002).contains(valueAsInt())
    }
}

class IssueYear(value: String) : Attribute(value) {
    override fun name(): String {
        return "iyr"
    }

    override fun isValid(): Boolean {
        return (2010..2020).contains(valueAsInt())
    }
}