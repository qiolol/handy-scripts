#!/usr/bin/env bash

# The desired number of decimal digits to round the result to
readonly DECIMAL_DIGITS=6

# `bc` uses this value for the desired digits after the decimal, but it also
# materially affects the results of calculations! For example,
# ```
# echo "scale=11; 15 * (1.07578*10^(-8))" | bc
# ```
# will yield the incorrect result `.00000016125`. Only when the scale increased
# to `13` does it give the correct result, `.0000001613670`. Therefore, this
# should be set to something very high to ensure accurate calculations. It does
# NOT directly control the number post-decimal digits in this program, so it's
# okay if it's very large.
readonly INTERNAL_PRECISION=100

################################################################################
#################################### LENGTH ####################################
################################################################################
# Unit symbols
readonly INCH="in"
readonly FOOT="ft"
readonly YARD="yd"
readonly MILE="mi"
readonly MILLIMETER="mm"
readonly CENTIMETER="cm"
readonly METER="m"
readonly KILOMETER="km"
readonly ASTRONOMICAL_UNIT="au"

# Unit symbols mapped to lowercase strings that a user can enter to indicate
# each unit
readonly -A LENGTH=\
(
    ["${INCH}"]="in \
                 ins \
                 inch \
                 inches"
    ["${FOOT}"]="ft \
                 fts \
                 foot \
                 feet"
    ["${YARD}"]="yd \
                 yds \
                 yard \
                 yards"
    ["${MILE}"]="mi \
                 mis \
                 mile \
                 miles"
    ["${MILLIMETER}"]="mm \
                       mms \
                       millimeter \
                       millimeters"
    ["${CENTIMETER}"]="cm \
                       cms \
                       centimeter \
                       centimeters"
    ["${METER}"]="m \
                  meter \
                  meters"
    ["${KILOMETER}"]="km \
                      kms \
                      kilometer \
                      kilometers"
    ["${ASTRONOMICAL_UNIT}"]="au \
                              aus \
                              astronomical-unit \
                              astronomical-units"
)

# Unit symbols mapped to their conversion to every other unit
#
# The nameref preceding each mapping allows code to refer to a mapping of
# conversions merely through the "from" unit string. For example:
#     1. `FROM_UNIT` is, after processing, the unit symbol "in".
#     2. `TO_UNIT` is, after processing, "ft".
#     3. Code selects the mapping named after `FROM_UNIT`, "in", which is
#        `INCH_CONVERSIONS`. This is the correct mapping for inches.
#     4. Code accesses the key named after `TO_UNIT`, "ft", to assign `NUMBER`
#        the correct conversion value to feet.
# (The nameref is necessary because variable expansion at the declaration of the
# mapping -- like `declare -A "${INCH}"=\` -- doesn't work.)
declare -n "${INCH}"="INCH_CONVERSIONS"
readonly -A INCH_CONVERSIONS=\
(
    ["${FOOT}"]="(1/12)"
    ["${YARD}"]="(1/36)"
    ["${MILE}"]="(1/63360)"
    ["${MILLIMETER}"]="25.4"
    ["${CENTIMETER}"]="2.54"
    ["${METER}"]="0.0254"
    ["${KILOMETER}"]="0.0000254"
    ["${ASTRONOMICAL_UNIT}"]="(1.69788513*10^(-13))"
)
declare -n "${FOOT}"="FOOT_CONVERSIONS"
readonly -A FOOT_CONVERSIONS=\
(
    ["${INCH}"]="12"
    ["${YARD}"]="(1/3)"
    ["${MILE}"]="(1/5280)"
    ["${MILLIMETER}"]="304.8"
    ["${CENTIMETER}"]="30.48"
    ["${METER}"]="0.3048"
    ["${KILOMETER}"]="0.0003048"
    ["${ASTRONOMICAL_UNIT}"]="(2.037462*10^(-12))"
)
declare -n "${YARD}"="YARD_CONVERSIONS"
readonly -A YARD_CONVERSIONS=\
(
    ["${INCH}"]="36"
    ["${FOOT}"]="3"
    ["${MILE}"]="(1/1760)"
    ["${MILLIMETER}"]="914.4"
    ["${CENTIMETER}"]="91.44"
    ["${METER}"]="0.9144"
    ["${KILOMETER}"]="0.0009144"
    ["${ASTRONOMICAL_UNIT}"]="(6.112386*10^(-12))"
)
declare -n "${MILE}"="MILE_CONVERSIONS"
readonly -A MILE_CONVERSIONS=\
(
    ["${INCH}"]="63360"
    ["${FOOT}"]="5280"
    ["${YARD}"]="1760"
    ["${MILLIMETER}"]="1609344"
    ["${CENTIMETER}"]="160934.4"
    ["${METER}"]="1609.344"
    ["${KILOMETER}"]="1.609344"
    ["${ASTRONOMICAL_UNIT}"]="(1.07578*10^(-8))"
)
declare -n "${MILLIMETER}"="MILLIMETER_CONVERSIONS"
readonly -A MILLIMETER_CONVERSIONS=\
(
    ["${INCH}"]="0.039370078740157"
    ["${FOOT}"]="0.0032808399"
    ["${YARD}"]="0.0010936133"
    ["${MILE}"]="0.0000006214"
    ["${CENTIMETER}"]="0.1"
    ["${METER}"]="0.001"
    ["${KILOMETER}"]="0.000001"
    ["${ASTRONOMICAL_UNIT}"]="(6.684587*10^(-15))"
)
declare -n "${CENTIMETER}"="CENTIMETER_CONVERSIONS"
readonly -A CENTIMETER_CONVERSIONS=\
(
    ["${INCH}"]="0.39370078740157"
    ["${FOOT}"]="0.032808398950131"
    ["${YARD}"]="0.010936133"
    ["${MILE}"]="0.0000062137"
    ["${MILLIMETER}"]="10"
    ["${METER}"]="0.01"
    ["${KILOMETER}"]="0.00001"
    ["${ASTRONOMICAL_UNIT}"]="(6.684587*10^(-14))"
)
declare -n "${METER}"="METER_CONVERSIONS"
readonly -A METER_CONVERSIONS=\
(
    ["${INCH}"]="39.3700787402"
    ["${FOOT}"]="3.280839895"
    ["${YARD}"]="1.0936132983"
    ["${MILE}"]="0.0006213712"
    ["${MILLIMETER}"]="1000"
    ["${CENTIMETER}"]="100"
    ["${KILOMETER}"]="0.001"
    ["${ASTRONOMICAL_UNIT}"]="(6.684587*10^(-12))"
)
declare -n "${KILOMETER}"="KILOMETER_CONVERSIONS"
readonly -A KILOMETER_CONVERSIONS=\
(
    ["${INCH}"]="39370.07874"
    ["${FOOT}"]="3280.84"
    ["${YARD}"]="1093.6132983377"
    ["${MILE}"]="0.6213711922"
    ["${MILLIMETER}"]="1000000"
    ["${CENTIMETER}"]="100000"
    ["${METER}"]="1000"
    ["${ASTRONOMICAL_UNIT}"]="(6.684587*10^(-9))"
)
declare -n "${ASTRONOMICAL_UNIT}"="ASTRONOMICAL_UNIT_CONVERSIONS"
readonly -A ASTRONOMICAL_UNIT_CONVERSIONS=\
(
    ["${INCH}"]="5889679948817.28"
    ["${FOOT}"]="490806662401.44"
    ["${YARD}"]="163602220800.48"
    ["${MILE}"]="92955807.2730"
    ["${MILLIMETER}"]="149597870700000"
    ["${CENTIMETER}"]="14959787070000"
    ["${METER}"]="149597870700"
    ["${KILOMETER}"]="149597870.7"
)

################################################################################
#################################### VOLUME ####################################
################################################################################
readonly CUP="cup"
readonly PINT="pt"
readonly QUART="qt"
readonly GALLON="gal"
readonly MILLILITER="mL"
readonly LITER="L"

readonly -A VOLUME=\
(
    ["${CUP}"]="cup \
                cups"
    ["${PINT}"]="pt \
                 pts \
                 pint \
                 pints"
    ["${QUART}"]="qt \
                  qts \
                  quart \
                  quarts"
    ["${GALLON}"]="gal \
                   gals \
                   gallon \
                   gallons"
    ["${MILLILITER}"]="ml \
                       mls \
                       milliliter \
                       milliliters"
    ["${LITER}"]="l \
                  ls \
                  liter \
                  liters"
)

declare -n "${CUP}"="CUP_CONVERSIONS"
readonly -A CUP_CONVERSIONS=\
(
    ["${PINT}"]="0.5"
    ["${QUART}"]="0.25"
    ["${GALLON}"]="0.0625"
    ["${MILLILITER}"]="236.5882365"
    ["${LITER}"]="0.2365882365"
)
declare -n "${PINT}"="PINT_CONVERSIONS"
readonly -A PINT_CONVERSIONS=\
(
    ["${CUP}"]="2"
    ["${QUART}"]="0.5"
    ["${GALLON}"]="0.125"
    ["${MILLILITER}"]="473.176473"
    ["${LITER}"]="0.473176473"
)
declare -n "${QUART}"="QUART_CONVERSIONS"
readonly -A QUART_CONVERSIONS=\
(
    ["${CUP}"]="4"
    ["${PINT}"]="2"
    ["${GALLON}"]="0.25"
    ["${MILLILITER}"]="946.352946"
    ["${LITER}"]="0.946352946"
)
declare -n "${GALLON}"="GALLON_CONVERSIONS"
readonly -A GALLON_CONVERSIONS=\
(
    ["${CUP}"]="16"
    ["${PINT}"]="8"
    ["${QUART}"]="4"
    ["${MILLILITER}"]="3785.411784"
    ["${LITER}"]="3.785411784"
)
declare -n "${MILLILITER}"="MILLILITER_CONVERSIONS"
readonly -A MILLILITER_CONVERSIONS=\
(
    ["${CUP}"]="0.0042267528"
    ["${PINT}"]="0.0021133764"
    ["${QUART}"]="0.0010566882"
    ["${GALLON}"]="0.0002641721"
    ["${LITER}"]="0.001"
)
declare -n "${LITER}"="LITER_CONVERSIONS"
readonly -A LITER_CONVERSIONS=\
(
    ["${CUP}"]="4.2267528377"
    ["${PINT}"]="2.1133764189"
    ["${QUART}"]="1.0566882094"
    ["${GALLON}"]="0.2641720524"
    ["${MILLILITER}"]="1000"
)

################################################################################
##################################### MASS #####################################
################################################################################
readonly OUNCE="oz"
readonly TROY_OUNCE="ozt"
readonly POUND="lb"
readonly GRAM="g"
readonly KILOGRAM="kg"

readonly -A MASS=\
(
    ["${OUNCE}"]="oz \
                  ozs \
                  ounce \
                  ounces"
    ["${TROY_OUNCE}"]="ozt \
                       troy-ounce \
                       troy-ounces"
    ["${POUND}"]="lb \
                  lbs \
                  pound \
                  pounds"
    ["${GRAM}"]="g \
                 gs \
                 gram \
                 grams"
    ["${KILOGRAM}"]="kg \
                     kgs \
                     kilogram \
                     kilograms"
)

declare -n "${OUNCE}"="OUNCE_CONVERSIONS"
readonly -A OUNCE_CONVERSIONS=\
(
    ["${TROY_OUNCE}"]="0.91145833"
    ["${POUND}"]="0.0625"
    ["${GRAM}"]="28.349523125"
    ["${KILOGRAM}"]="0.0283495231"
)
declare -n "${TROY_OUNCE}"="TROY_OUNCE_CONVERSIONS"
readonly -A TROY_OUNCE_CONVERSIONS=\
(
    ["${OUNCE}"]="1.0971428571"
    ["${POUND}"]="0.0685714286"
    ["${GRAM}"]="31.10347680"
    ["${KILOGRAM}"]="0.0311034768"
)
declare -n "${POUND}"="POUND_CONVERSIONS"
readonly -A POUND_CONVERSIONS=\
(
    ["${OUNCE}"]="16"
    ["${TROY_OUNCE}"]="14.58333328"
    ["${GRAM}"]="453.59237"
    ["${KILOGRAM}"]="0.45359237"
)
declare -n "${GRAM}"="GRAM_CONVERSIONS"
readonly -A GRAM_CONVERSIONS=\
(
    ["${OUNCE}"]="0.0352739619"
    ["${TROY_OUNCE}"]=".032150746405857627"
    ["${POUND}"]="0.0022046226"
    ["${KILOGRAM}"]="0.001"
)
declare -n "${KILOGRAM}"="KILOGRAM_CONVERSIONS"
readonly -A KILOGRAM_CONVERSIONS=\
(
    ["${OUNCE}"]="35.27396195"
    ["${TROY_OUNCE}"]="32.15074645"
    ["${POUND}"]="2.2046226218"
    ["${GRAM}"]="1000"
)

################################################################################
################################## TEMPERATURE #################################
################################################################################
readonly FAHRENHEIT="F"
readonly CELSIUS="C"
readonly KELVIN="K"

readonly -A TEMPERATURE=\
(
    ["${FAHRENHEIT}"]="f \
                       °f \
                       fahrenheit"
    ["${CELSIUS}"]="c \
                    °c \
                    celsius"
    ["${KELVIN}"]="k \
                   kelvin"
)

################################################################################
##################################### TIME #####################################
################################################################################
readonly SECOND="s"
readonly MINUTE="min"
readonly HOUR="h"
readonly DAY="d"
# Gregorian calendar units
readonly WEEK="week"
readonly MONTH="month"
readonly YEAR="year"

readonly -A TIME=\
(
    ["${SECOND}"]="s \
                   sec \
                   secs \
                   second \
                   seconds"
    ["${MINUTE}"]="min \
                   mins \
                   minute \
                   minutes"
    ["${HOUR}"]="h \
                 hr \
                 hrs \
                 hour \
                 hours"
    ["${DAY}"]="d \
                day \
                days"
    ["${WEEK}"]="wk \
                 wks \
                 week \
                 weeks"
    ["${MONTH}"]="mon \
                  mons \
                  month \
                  months"
    ["${YEAR}"]="yr \
                 yrs \
                 year \
                 years"
)

declare -n "${SECOND}"="SECOND_CONVERSIONS"
readonly -A SECOND_CONVERSIONS=\
(
    ["${MINUTE}"]="(1/60)"
    ["${HOUR}"]="(1/3600)"
    ["${DAY}"]="(1/86400)"
    ["${WEEK}"]="(1/604800)"
    ["${MONTH}"]="(3.805175038*10^(-7))"
    ["${YEAR}"]="(3.168808781*10^(-8))"
)
declare -n "${MINUTE}"="MINUTE_CONVERSIONS"
readonly -A MINUTE_CONVERSIONS=\
(
    ["${SECOND}"]="60"
    ["${HOUR}"]="(1/60)"
    ["${DAY}"]="(1/1440)"
    ["${WEEK}"]="(1/10080)"
    ["${MONTH}"]="0.0000228311"
    ["${YEAR}"]="0.0000019013"
)
declare -n "${HOUR}"="HOUR_CONVERSIONS"
readonly -A HOUR_CONVERSIONS=\
(
    ["${SECOND}"]="3600"
    ["${MINUTE}"]="60"
    ["${DAY}"]="(1/24)"
    ["${WEEK}"]="0.005952381"
    ["${MONTH}"]="0.001369863"
    ["${YEAR}"]="0.0001140771"
)
declare -n "${DAY}"="DAY_CONVERSIONS"
readonly -A DAY_CONVERSIONS=\
(
    ["${SECOND}"]="86400"
    ["${MINUTE}"]="1440"
    ["${HOUR}"]="24"
    ["${WEEK}"]="0.1428571429"
    ["${MONTH}"]="0.0328767123"
    ["${YEAR}"]="0.0027378508"
)
declare -n "${WEEK}"="WEEK_CONVERSIONS"
readonly -A WEEK_CONVERSIONS=\
(
    ["${SECOND}"]="604800"
    ["${MINUTE}"]="10080"
    ["${HOUR}"]="168"
    ["${DAY}"]="7"
    ["${MONTH}"]="0.2301369863"
    ["${YEAR}"]="0.0191649555"
)
declare -n "${MONTH}"="MONTH_CONVERSIONS"
readonly -A MONTH_CONVERSIONS=\
(
    ["${SECOND}"]="2628000"
    ["${MINUTE}"]="43800"
    ["${HOUR}"]="730"
    ["${DAY}"]="30.416666667"
    ["${WEEK}"]="4.3452380952"
    ["${YEAR}"]="0.0832762948"
)
declare -n "${YEAR}"="YEAR_CONVERSIONS"
readonly -A YEAR_CONVERSIONS=\
(
    ["${SECOND}"]="31557600"
    ["${MINUTE}"]="525960"
    ["${HOUR}"]="8766"
    ["${DAY}"]="365.25"
    ["${WEEK}"]="52.178571429"
    ["${MONTH}"]="12.008219178"
)

################################################################################
############################### SPECIAL STRINGS ################################
################################################################################
readonly -A SPECIAL_STRINGS=\
(
    ["pi"]="(a(1)*4)"
    ["\([0-9]\+\)e\([0-9]\+\)"]="(\1*10^\2)" # E notation: "1e3" -> "(1*10^3)"
)

function print_usage()
{
    echo -e "\
USAGES
\t${0} <math-expression>
\t${0} <number> <from> <to>

EXAMPLES
\t${0} 22/7
\t${0} 2^4 + 2^4 - 2^5
\t${0} \"2 * (3 + 4)\"
\t${0} 1e3 \* pi
\t${0} 400 troy-ounces to lbs
\t${0} 68 F C
\t${0} 1 week to hrs

DESCRIPTION
\tA number cruncher

\tThis script's name is a reference to Leeroy Jenkins. Also, the name \"Abdul\"
\tis a combination of the Arabic words \"abd\" (meaning \"servant\") and the
\tdefinite prefix \"al\"/\"el\" (meaning \"the\"). This script serves as a
\twrapper around \`bc\`, enabling its use with more convenient \`expr\`-like
\tsyntax, and as a converter between various imperial, metric, and Gregorian
\tcalendar units.

\t\`bc\`, \`sed\`, \`printf\`, \`read\`, and Bash 4.3+ required

PARAMETERS
\tmath-expression\tAny mathematical expression supported by \`bc\`
\t\t\tNote that '*' has to be escaped, like \"\*\", or in quotes in
\t\t\torder to not get expanded by Bash. Also, parentheses like
\t\t\t\"(3 + 4)\" have to be in quotes to not be treated as subshells.

\tnumber\t\tA positive number of \"from\" units to convert
\tfrom\t\tUnit to convert from
\tto\t\tUnit to convert to

SUPPORTED UNITS
\tLength
\t\tInches (in)
\t\tFeet (ft)
\t\tYards (yd)
\t\tMiles (mi)
\t\tMillimeters (mm)
\t\tCentimeters (cm)
\t\tMeters (m)
\t\tKilometers (km)
\t\tAstronomical units (au)

\tVolume
\t\tCups
\t\tPints (pt)
\t\tQuarts (qt)
\t\tGallons (gal)
\t\tMilliliters (mL)
\t\tLiters (L)

\tMass
\t\tOunces (oz)
\t\tTroy ounces (ozt)
\t\tPounds (lb)
\t\tGrams (g)
\t\tKilograms (kg)

\tTemperature
\t\tFahrenheit (F)
\t\tCelsius (C)
\t\tKelvin (K)

\tTime (Gregorian calendar)
\t\tSeconds (s)
\t\tMinutes (min)
\t\tHours (h)
\t\tDays (d)
\t\tWeeks
\t\tMonths
\t\tYears

SPECIAL STRINGS
\tThese strings, while not supported by \`bc\`, are auto-translated to their
\tequivalents in \`bc\` math expressions (but NOT unit conversions) for
\tconvenience:

\tpi\t\tGets replaced by the value of the mathematical constant pi (π)
\tE notation\tThe 'e' in a number like \"1e3\" gets replaced by \"*10^\""
}

# Tries processing input as a math expression by running it through `bc`
function evaluate_math_expression()
{
    # `bc` doesn't emit an exit status code; on an error, it'll complain on
    # `stderr` and send nothing to `stdout`. Since the input might not actually
    # be a math expression, redirect `stderr` to `/dev/null`.
    #
    # Also, results longer than 70 characters get truncated with `\` and a
    # newline, which causes problems with `printf`. To get around this, use
    # `read`.
    read RESULT <<< $(bc -l 2> /dev/null <<< \
                      "scale=${INTERNAL_PRECISION}; ${@}")

    if [[ ! "${RESULT}" ]]
    then
        return 1
    fi

    return 0
}

# Checks if the globals `FROM_UNIT` and `TO_UNIT` belong to the unit symbol
# mapping given as `$1` and, if they do, rectifies them to their proper unit
# symbol (e.g., setting "milliliters" to "mL")
function units_in()
{
    local FROM_MATCHED=false
    local TO_MATCHED=false
    local -n MAPPING_REF="${1}"

    for UNIT in "${!MAPPING_REF[@]}"
    do
        local -a UNIT_INPUT_STRINGS=(${MAPPING_REF["${UNIT}"]})

        for POSSIBLE_INPUT_STRING in "${UNIT_INPUT_STRINGS[@]}"
        do
            if [[ "${FROM_UNIT}" == "${POSSIBLE_INPUT_STRING}" ]]
            then
                FROM_MATCHED="true"
                FROM_UNIT="${UNIT}" # Rectify to proper unit symbol
            fi

            if [[ "${TO_UNIT}" == "${POSSIBLE_INPUT_STRING}" ]]
            then
                TO_MATCHED="true"
                TO_UNIT="${UNIT}"
            fi
        done
    done

    if $FROM_MATCHED && $TO_MATCHED
    then
        return 0
    else
        return 1
    fi
}

# Tries processing input as a unit conversion
function evaluate_unit_conversion()
{
    # Extract the number and units.
    local -r REGEX="^([0-9^.,]+)\s+(\S+)\s+(to)?\s*(\S+)\s*$"

    if ! [[ "${@}" =~ ${REGEX} ]]
    then
        return 1 # Input is in incorrect format!
    fi

    local -r NUMBER="${BASH_REMATCH[1]}"
    FROM_UNIT="${BASH_REMATCH[2]}"
    # `[3]` will always be the optional "to", regardless if present.
    TO_UNIT="${BASH_REMATCH[4]}"

    # Check if the units are recognized and exist in the same category.
    if ! units_in LENGTH &&
       ! units_in VOLUME &&
       ! units_in MASS &&
       ! units_in TEMPERATURE &&
       ! units_in TIME
    then
        return 1 # One or both of the units are not recognized!
    fi

    if [[ "${FROM_UNIT}" == "${TO_UNIT}" ]]
    then
        return 1 # The "from" and "to" units are exactly the same!
    fi

    # Do the conversion.
    if [[ "${FROM_UNIT}" == "${FAHRENHEIT}" ||
          "${FROM_UNIT}" == "${CELSIUS}" ||
          "${FROM_UNIT}" == "${KELVIN}" ]]
    then
        # Temperature conversions use the classic, hardcoded formula.
        if [[ "${FROM_UNIT}" == "${FAHRENHEIT}" ]]
        then
            if [[ "${TO_UNIT}" == "${CELSIUS}" ]]
            then
                local -r FORMULA="(${NUMBER} - 32) * 5 / 9"
            else
                local -r FORMULA="((${NUMBER} - 32) * 5 / 9) + 273.15"
            fi
        elif [[ "${FROM_UNIT}" == "${CELSIUS}" ]]
        then
            if [[ "${TO_UNIT}" == "${FAHRENHEIT}" ]]
            then
                local -r FORMULA="${NUMBER} / 5 * 9 + 32"
            else
                local -r FORMULA="${NUMBER} + 273.15"
            fi
        else
            if [[ "${TO_UNIT}" == "${FAHRENHEIT}" ]]
            then
                local -r FORMULA="(${NUMBER} - 273.15) / 5 * 9 + 32"
            else
                local -r FORMULA="${NUMBER} - 273.15"
            fi
        fi

        read RESULT <<< $(bc -l 2> /dev/null <<< \
                          "scale=${INTERNAL_PRECISION}; ${FORMULA}")
    else
        # Non-temperature conversions are just multiplication by a ratio.
        local -n MAPPING_REF="${FROM_UNIT}"
        local -r CONVERSION_RATIO=${MAPPING_REF[${TO_UNIT}]}
        read RESULT <<< $(bc -l 2> /dev/null <<< \
                          "scale=${INTERNAL_PRECISION}; \
                          ${NUMBER} * ${CONVERSION_RATIO}")
    fi

    if [[ ! "${RESULT}" ]]
    then
        return 1 # Conversion failed!
    fi

    return 0
}

# Replaces all special strings in `$1`
function replace_special_strings()
{
    local TEMP_INPUT="${@}"

    for STRING in "${!SPECIAL_STRINGS[@]}"
    do
        REPLACEMENT_STRING="${SPECIAL_STRINGS[${STRING}]}"

        TEMP_INPUT=$(echo "${TEMP_INPUT}" |
                     sed "s/${STRING}/${REPLACEMENT_STRING}/g")
    done

    echo -e "${TEMP_INPUT}"
}

# Rounds the `RESULT` to `DECIMAL_DIGITS` decimal places
function round_to_decimal_digits()
{
    RESULT=$(printf %."${DECIMAL_DIGITS}"f "${RESULT}")
}

# Turns a `RESULT` that looks like these
# ```
# 0000.02000
# 123.00
# ```
# into looking like these:
# ```
# 0.02
# 123
# ```
function strip_result_zeroes()
{
    RESULT=$(echo "${RESULT}" | sed "/\./ s/\.\{0,1\}0\{1,\}$//")
}

# Records whether `RESULT` digits repeat after the decimal point
function repeating_result_decimal_digits()
{
    local -r REGEX="^[0-9]*\.([0-9]+)\1+$"

    if [[ ${RESULT} =~ ${REGEX} ]]
    then
        readonly RESULT_REPEATS=true
    fi
}

# Reports the `RESULT` to the user
function report_result()
{
    round_to_decimal_digits
    strip_result_zeroes
    repeating_result_decimal_digits

    echo "${RESULT}"
    if [[ "${RESULT_REPEATS}" ]]
    then
        echo "(Repeating, of course)"
    fi
}

readonly INPUT="${@,,}" # Lowercased for easier processing
readonly REPLACED_INPUT="$(replace_special_strings "${INPUT}")"

# First, try processing the input with string replacement as a `bc` expression.
# (Trying the input WITHOUT string replacement first doesn't work since `bc`
# will evaluate "pi", for example, as "0". Since "0" is a valid output, we don't
# know whether the command failed because the special string "pi" wasn't
# replaced. Also, `bc` expressions without special strings will be unaffected by
# string replacement.)
if evaluate_math_expression "${REPLACED_INPUT}" ||
   # If it didn't seem like a `bc` expression, try unit conversion (but without
   # string replacement as special strings aren't supported in conversions).
   evaluate_unit_conversion "${INPUT}"
then
    report_result

    exit 0
fi

print_usage

exit 1
