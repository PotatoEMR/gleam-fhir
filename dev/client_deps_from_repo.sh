# ai generated idk
# sets gleam.toml to use hex.pm/github

set -e

cd ..

# Pinned commit SHAs of base repos' main branches
SHA_R4B=3954d526b333e694a6eddb5a86c6a38b7fcc9152
SHA_R4P=8e1a07bc565bddf5fdd546910b58464031fa2575
SHA_R4US=097125878c770ce1604b676b98997c9fac65688e
SHA_R5=6851ff903447f7e185893c39146eef0dfc57c315

cd fhir_client_httpc
FHIR_VERSION=$(sed -n 's/^version = "\(.*\)"/\1/p' gleam.toml)
sed -i "s|^fhir = .*|fhir = \"$FHIR_VERSION\"|" gleam.toml
rm -f manifest.toml

cd ../fhir_client_rsvp
FHIR_VERSION=$(sed -n 's/^version = "\(.*\)"/\1/p' gleam.toml)
sed -i "s|^fhir = .*|fhir = \"$FHIR_VERSION\"|" gleam.toml
rm -f manifest.toml

cd ../fhir_r4b_client_httpc
sed -i "s|^fhir_r4b = .*|fhir_r4b = { git = \"https://github.com/PotatoEMR/fhir_r4b\", ref = \"$SHA_R4B\" }|" gleam.toml
rm -f manifest.toml

cd ../fhir_r4b_client_rsvp
sed -i "s|^fhir_r4b = .*|fhir_r4b = { git = \"https://github.com/PotatoEMR/fhir_r4b\", ref = \"$SHA_R4B\" }|" gleam.toml
rm -f manifest.toml

cd ../fhir_r4p_client_httpc
sed -i "s|^fhir_r4p = .*|fhir_r4p = { git = \"https://github.com/PotatoEMR/fhir_r4p\", ref = \"$SHA_R4P\" }|" gleam.toml
rm -f manifest.toml

cd ../fhir_r4p_client_rsvp
sed -i "s|^fhir_r4p = .*|fhir_r4p = { git = \"https://github.com/PotatoEMR/fhir_r4p\", ref = \"$SHA_R4P\" }|" gleam.toml
rm -f manifest.toml

cd ../fhir_r4us_client_httpc
sed -i "s|^fhir_r4us = .*|fhir_r4us = { git = \"https://github.com/PotatoEMR/fhir_r4us\", ref = \"$SHA_R4US\" }|" gleam.toml
rm -f manifest.toml

cd ../fhir_r4us_client_rsvp
sed -i "s|^fhir_r4us = .*|fhir_r4us = { git = \"https://github.com/PotatoEMR/fhir_r4us\", ref = \"$SHA_R4US\" }|" gleam.toml
rm -f manifest.toml

cd ../fhir_r5_client_httpc
sed -i "s|^fhir_r5 = .*|fhir_r5 = { git = \"https://github.com/PotatoEMR/fhir_r5\", ref = \"$SHA_R5\" }|" gleam.toml
rm -f manifest.toml

cd ../fhir_r5_client_rsvp
sed -i "s|^fhir_r5 = .*|fhir_r5 = { git = \"https://github.com/PotatoEMR/fhir_r5\", ref = \"$SHA_R5\" }|" gleam.toml
rm -f manifest.toml

echo "Client gleam.toml dependencies now point at git refs."
