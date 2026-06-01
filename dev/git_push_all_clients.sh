# split because pipeline test gets mad if you push a client pkg without having already pushed its dependency

cd ../fhir_client_httpc
git add .
git commit -m "0.7.0 git ref"
git push

cd ../fhir_client_rsvp
git add .
git commit -m "0.7.0 git ref"
git push

cd ../fhir_r4b_client_httpc
git add .
git commit -m "0.7.0 git ref"
git push

cd ../fhir_r4b_client_rsvp
git add .
git commit -m "0.7.0 git ref"
git push

cd ../fhir_r4p_client_httpc
git add .
git commit -m "0.7.0 git ref"
git push

cd ../fhir_r4p_client_rsvp
git add .
git commit -m "0.7.0 git ref"
git push

cd ../fhir_r4us_client_httpc
git add .
git commit -m "0.7.0 git ref"
git push

cd ../fhir_r4us_client_rsvp
git add .
git commit -m "0.7.0 git ref"
git push

cd ../fhir_r5_client_httpc
git add .
git commit -m "0.7.0 git ref"
git push

cd ../fhir_r5_client_rsvp
git add .
git commit -m "0.7.0 git ref"
git push
