def preview(df):
    log.info(df.head())
    return df


def initialize(context):
    set_symbol_lookup_date('2013-01-04')
    schedule_function(my_handle_data,
                      date_rules.every_day(),
                      time_rules.market_open(hours=1))
    fetch_csv(
        'https://docs.google.com/spreadsheets/d/e/2PACX-1vRjPvU89MQWkFF7UcHqmGqDXL9gDZ5ttN45UTMR_sJz__zaf7dBhjUchqwJlmCFJY-bg_QbjMaxZKPB/pub?gid=1111307141&single=true&output=csv',
        pre_func=preview)

    context.stocks = symbols('AAPL', 'AMZN', 'FB', 'GOOG', 'MSFT', 'NFLX', 'NVDA', 'TSLA')


def my_handle_data(context, data):
    try:
        for s in data:
            if 'signal' in data[s]:
                print(s, data[s]['signal'])
                sentiment = data[s]['signal']
                current_position = context.portfolio.positions[s].amount

                if (sentiment == 1) and (current_position == 0):
                    order_target_percent(s, 0.25)

                elif (sentiment == -1) and (current_position > 0):
                    order_target(s, 0)


    except Exception as e:
        print(str(e))