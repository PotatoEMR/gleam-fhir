cd ../fhir_r4b && gleam deps update && cd -
cd ../fhir_r4us && gleam deps update && cd -
cd ../fhir_r4p && gleam deps update && cd -
cd ../fhir_r5 && gleam deps update && cd -
cd ../fhir_client_httpc && gleam deps update && cd -
cd ../fhir_client_rsvp && gleam deps update && cd -
cd ../fhir_r4b_client_httpc && gleam deps update && cd -
cd ../fhir_r4b_client_rsvp && gleam deps update && cd -
cd ../fhir_r4p_client_httpc && gleam deps update && cd -
cd ../fhir_r4p_client_rsvp && gleam deps update && cd -
cd ../fhir_r4us_client_httpc && gleam deps update && cd -
cd ../fhir_r4us_client_rsvp && gleam deps update && cd -
cd ../fhir_r5_client_httpc && gleam deps update && cd -
cd ../fhir_r5_client_rsvp && gleam deps update && cd -
gleam build
