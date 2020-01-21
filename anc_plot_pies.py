#!/usr/bin/env python3

# usage: ./anc_plot_pies.py <source.anc> [<category_1> ... [<category_n>] ]


import sys
import collections
import datetime
import locale
import dateutil.relativedelta
import openpyxl as pxl
import matplotlib.pyplot as plt

# data and language format-specific constants
RECORD_SEPARATOR = "\n"
RECORD_FIELD_SEPARATOR = ";"
DATE_FORMAT = "%Y.%m.%d.%H.%M.%S"
CURRENCY_SYMBOL = "€"
NUMBER_DECIMAL_SEPARATOR = ","
NUMBER_IRRELEVANT_SEPARATOR = "."
#
DATE_NAME = "Datum"
AMOUNT_NAME = "Betrag"
TAGS_NAME = "Tags"
MISC_NAME = "Sonstiges"
OVERVIEW_NAME = "Übersicht"
JUNCTION_NAME = "und"
YEARS_AGO_ANME = " Jahr(e) zurück"
MONTHS_AGO_ANME = " Monat(e) zurück"
#
locale.setlocale(locale.LC_ALL, "de_DE.UTF-8")


def amount_to_str(amount):
    return (
        locale.format("%.2f", amount, grouping=True, monetary=True)
        + CURRENCY_SYMBOL
    )


def convert_string(field_str):
    return field_str


def convert_date(field_str):
    return datetime.datetime.strptime(field_str, DATE_FORMAT)


def convert_currency(field_str):
    return int(
        100
        * float(
            field_str.strip(CURRENCY_SYMBOL)
            .replace(NUMBER_IRRELEVANT_SEPARATOR, "")
            .replace(NUMBER_DECIMAL_SEPARATOR, ".")
            .strip()
        )
    )


field_converters = collections.defaultdict(lambda: convert_string)
field_converters[1] = convert_date
field_converters[2] = convert_currency

field_names = collections.defaultdict(lambda: None)
field_names[1] = DATE_NAME
field_names[2] = AMOUNT_NAME
field_names[3] = TAGS_NAME


def get_category(record_str, categories):
    for category in categories:
        if category in record_str:
            return category
    return MISC_NAME


def get_database(source, categories):

    database = {MISC_NAME: []}
    for category in categories:
        database[category] = []

    with open(source, "r") as source_file:
        current_record_nr = 1
        for record_str in source_file.read().split(RECORD_SEPARATOR):
            if record_str != "":
                record = []
                category = get_category(record_str, categories)
                current_field_nr = 1
                for field_str in record_str.split(RECORD_FIELD_SEPARATOR):
                    field_value = None
                    try:
                        field_value = field_converters[current_field_nr](
                            field_str
                        )
                    except Exception as e:
                        print(
                            "WARNING: Convert error for field "
                            + str(current_field_nr)
                            + " in record "
                            + str(current_record_nr)
                            + ":\n"
                            + str(e)
                        )
                    record.append(field_value)
                    current_field_nr += 1
                database[category].append(record)
            current_record_nr += 1

    return database


def positive_amount(record):
    return record[1] > 0


positive_amount.discriminator_description = "+"


def negative_amount(record):
    return record[1] < 0


negative_amount.discriminator_description = "-"


def past_year(delta_year_from_now):
    def discriminator(record):
        other = datetime.datetime.now() - dateutil.relativedelta.relativedelta(
            years=delta_year_from_now
        )
        this = record[0]
        return this.year == other.year

    discriminator.discriminator_description = (
        str(delta_year_from_now) + " " + YEARS_AGO_ANME
    )

    return discriminator


def past_month(delta_month_from_now):
    def discriminator(record):
        other = datetime.datetime.now() - dateutil.relativedelta.relativedelta(
            months=delta_month_from_now
        )
        this = record[0]
        return this.year == other.year and this.month == other.month

    discriminator.discriminator_description = (
        str(delta_month_from_now) + " " + MONTHS_AGO_ANME
    )

    return discriminator


def junction(lhs, rhs):
    f = lambda x: lhs(x) and rhs(x)
    f.discriminator_description = (
        lhs.discriminator_description
        + " "
        + JUNCTION_NAME
        + " "
        + rhs.discriminator_description
    )
    return f


def plot_database(database):

    max_past_years = 1
    max_past_month = 2
    fig, axes = plt.subplots(1 + (max_past_years + 1) + (max_past_month + 1), 2)
    row_index = 0
    for n in range(max_past_month + 1):
        plot_database_with_discriminator(
            axes[row_index][0],
            database,
            junction(past_month(n), negative_amount),
        )
        plot_database_with_discriminator(
            axes[row_index][1],
            database,
            junction(past_month(n), positive_amount),
        )
        row_index += 1
    for n in range(max_past_years + 1):
        plot_database_with_discriminator(
            axes[row_index][0],
            database,
            junction(past_year(n), negative_amount),
        )
        plot_database_with_discriminator(
            axes[row_index][1],
            database,
            junction(past_year(n), positive_amount),
        )
        row_index += 1
    plot_database_with_discriminator(
        axes[row_index][0], database, negative_amount
    )
    plot_database_with_discriminator(
        axes[row_index][1], database, positive_amount
    )
    row_index += 1
    fig.suptitle(OVERVIEW_NAME)
    plt.tight_layout()  # separate the subplot a little bit more
    plt.show()


def plot_database_with_discriminator(axes, database, discriminator):
    categories = list(database.keys())
    data = [
        sum([record[1] for record in database[cat] if discriminator(record)])
        / 100.0
        for cat in categories
    ]
    for i in range(len(data) - 1, -1, -1):
        if data[i] == 0.0:
            del data[i]
            del categories[i]
    total = sum(data)
    percentages = list(map(lambda x: float(x) / total, data))
    labels = list(
        map(
            lambda x: x[0]
            + " ("
            + amount_to_str(x[1])
            + "; "
            + ("%0.1f" % (x[2] * 100.0))
            + "%)",
            zip(categories, data, percentages),
        )
    )
    axes.pie(percentages, labels=labels, startangle=0)  # , autopct="%1.1f"
    axes.axis("equal")
    axes.title.set_text(
        discriminator.discriminator_description
        + " ("
        + amount_to_str(total)
        + ")"
    )


if __name__ == "__main__":
    database = get_database(source=sys.argv[1], categories=sys.argv[2:])
    plot_database(database)
