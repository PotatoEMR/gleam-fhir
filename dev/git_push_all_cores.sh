# split because pipeline test gets mad if you push a client pkg without having already pushed its dependency

cd ../fhir_r4b
git add .
git commit -m "0.8.0"
git push

cd ../fhir_r4us
git add .
git commit -m "0.8.0"
git push

cd ../fhir_r4p
git add .
git commit -m "0.8.0"
git push

cd ../fhir_r5
git add .
git commit -m "0.8.0"
git push
