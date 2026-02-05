These examples fail to parse in parse_json_examples.gleam
It seems like the examples don't comply with the spec:
r4 questionnaire items mising linkId
r4b missing publication status

currently making no effort to parse json where it doesn't comply with spec
so just ignoring these (parse_json_examples.gleam only checks r4-examples-json, r4b-examples-json, r5-examples-json)

tbh these may comply with spec but do things I don't realize or haven't implemented yet...
