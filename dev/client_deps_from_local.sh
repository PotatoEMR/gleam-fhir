# ai generated idk
# sets gleam.toml to use local repo for testing

set -e

cd ..

cd fhir_client_httpc
sed -i "s|^fhir = .*|fhir = { path = \"../gleam-fhir\" }|" gleam.toml

cd ../fhir_client_rsvp
sed -i "s|^fhir = .*|fhir = { path = \"../gleam-fhir\" }|" gleam.toml

cd ../fhir_r4b_client_httpc
sed -i "s|^fhir_r4b = .*|fhir_r4b = { path = \"../fhir_r4b\" }|" gleam.toml

cd ../fhir_r4b_client_rsvp
sed -i "s|^fhir_r4b = .*|fhir_r4b = { path = \"../fhir_r4b\" }|" gleam.toml

cd ../fhir_r4p_client_httpc
sed -i "s|^fhir_r4p = .*|fhir_r4p = { path = \"../fhir_r4p\" }|" gleam.toml

cd ../fhir_r4p_client_rsvp
sed -i "s|^fhir_r4p = .*|fhir_r4p = { path = \"../fhir_r4p\" }|" gleam.toml

cd ../fhir_r4us_client_httpc
sed -i "s|^fhir_r4us = .*|fhir_r4us = { path = \"../fhir_r4us\" }|" gleam.toml

cd ../fhir_r4us_client_rsvp
sed -i "s|^fhir_r4us = .*|fhir_r4us = { path = \"../fhir_r4us\" }|" gleam.toml

cd ../fhir_r5_client_httpc
sed -i "s|^fhir_r5 = .*|fhir_r5 = { path = \"../fhir_r5\" }|" gleam.toml

cd ../fhir_r5_client_rsvp
sed -i "s|^fhir_r5 = .*|fhir_r5 = { path = \"../fhir_r5\" }|" gleam.toml

echo "Client gleam.toml dependencies now point at local FHIR packages."
