#!/usr/bin/env bash

set -e

R4B=$(git -C ../fhir_r4b rev-parse HEAD)
R4P=$(git -C ../fhir_r4p rev-parse HEAD)
R4US=$(git -C ../fhir_r4us rev-parse HEAD)
R5=$(git -C ../fhir_r5 rev-parse HEAD)

sed -i "s|^fhir_r4b = .*|fhir_r4b = { git = \"https://github.com/PotatoEMR/fhir_r4b\", ref = \"$R4B\" }|" ../fhir_r4b_client_httpc/gleam.toml
sed -i "s|^fhir_r4b = .*|fhir_r4b = { git = \"https://github.com/PotatoEMR/fhir_r4b\", ref = \"$R4B\" }|" ../fhir_r4b_client_rsvp/gleam.toml

sed -i "s|^fhir_r4p = .*|fhir_r4p = { git = \"https://github.com/PotatoEMR/fhir_r4p\", ref = \"$R4P\" }|" ../fhir_r4p_client_httpc/gleam.toml
sed -i "s|^fhir_r4p = .*|fhir_r4p = { git = \"https://github.com/PotatoEMR/fhir_r4p\", ref = \"$R4P\" }|" ../fhir_r4p_client_rsvp/gleam.toml

sed -i "s|^fhir_r4us = .*|fhir_r4us = { git = \"https://github.com/PotatoEMR/fhir_r4us\", ref = \"$R4US\" }|" ../fhir_r4us_client_httpc/gleam.toml
sed -i "s|^fhir_r4us = .*|fhir_r4us = { git = \"https://github.com/PotatoEMR/fhir_r4us\", ref = \"$R4US\" }|" ../fhir_r4us_client_rsvp/gleam.toml

sed -i "s|^fhir_r5 = .*|fhir_r5 = { git = \"https://github.com/PotatoEMR/fhir_r5\", ref = \"$R5\" }|" ../fhir_r5_client_httpc/gleam.toml
sed -i "s|^fhir_r5 = .*|fhir_r5 = { git = \"https://github.com/PotatoEMR/fhir_r5\", ref = \"$R5\" }|" ../fhir_r5_client_rsvp/gleam.toml
