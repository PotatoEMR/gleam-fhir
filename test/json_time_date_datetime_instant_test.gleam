import check_roundtrip
import fhir/r4

// Patient with birthDate (date), deceasedDateTime (dateTime), meta.lastUpdated (instant)
const patient_json = "{
  \"resourceType\": \"Patient\",
  \"id\": \"example-patient\",
  \"meta\": {
    \"versionId\": \"1\",
    \"lastUpdated\": \"2024-03-15T14:30:00.123Z\"
  },
  \"name\": [
    {
      \"family\": \"Smith\",
      \"given\": [\"John\"]
    }
  ],
  \"birthDate\": \"1990-07-15\",
  \"deceasedDateTime\": \"2024-01-20T08:15:00-05:00\"
}"

// HealthcareService with availableTime containing time fields
const healthcare_service_json = "{
  \"resourceType\": \"HealthcareService\",
  \"id\": \"example-service\",
  \"meta\": {
    \"lastUpdated\": \"2024-06-01T12:00:00Z\"
  },
  \"active\": true,
  \"availableTime\": [
    {
      \"daysOfWeek\": [\"mon\", \"tue\", \"wed\"],
      \"allDay\": false,
      \"availableStartTime\": \"08:30:00\",
      \"availableEndTime\": \"17:00:00.000\"
    }
  ]
}"

pub fn patient_primitives_roundtrip_test() {
  check_roundtrip.check_roundtrip(
    patient_json,
    r4.patient_decoder(),
    r4.patient_to_json,
    "patient_primitives",
  )
}

pub fn healthcareservice_time_roundtrip_test() {
  check_roundtrip.check_roundtrip(
    healthcare_service_json,
    r4.healthcareservice_decoder(),
    r4.healthcareservice_to_json,
    "healthcareservice_time",
  )
}
