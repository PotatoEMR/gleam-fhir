# rsvp 

`fhir/r4/client_rsvp` creates an `Effect` to give to Lustre, which will go make the request and come back with a message. This example has much more going on, in order to run in a browser using [Model-View-Update](https://hexdocs.pm/lustre/guide/02-state-management.html).

```gleam
// IMPORTS ---------------------------------------------------------------------

import fhir/r4/client_rsvp
import fhir/r4/resources
import fhir/r4/sansio
import gleam/option.{type Option, None, Some}
import lustre
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html

// MAIN ------------------------------------------------------------------------

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

// MODEL -----------------------------------------------------------------------

type Model {
  Model(client: client_rsvp.FhirClient, curr_pat: Option(resources.Patient))
}

fn init(_) -> #(Model, Effect(Msg)) {
  let assert Ok(client) = sansio.fhirclient_new("https://r4.smarthealthit.org")
  let model = Model(client: client, curr_pat: None)
  let read: Effect(Msg) =
    client_rsvp.patient_read(
      "87a339d0-8cae-418e-89c7-8651e6aab3c6",
      model.client,
      ServerReturnedPatient,
    )
  #(model, read)
}

// UPDATE ----------------------------------------------------------------------

type Msg {
  ServerReturnedPatient(Result(resources.Patient, client_rsvp.Err))
}

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    ServerReturnedPatient(Ok(pat)) -> {
      #(Model(..model, curr_pat: Some(pat)), effect.none())
    }
    ServerReturnedPatient(Error(_err)) -> {
      #(model, effect.none())
    }
  }
}

// VIEW ------------------------------------------------------------------------

fn view(model: Model) -> Element(Msg) {
  case model.curr_pat {
    None -> html.p([], [html.text("none")])
    Some(pat) -> {
      html.p([], [
        html.text(
          "patient id: "
          <> case pat.id {
            None -> "none"
            Some(id) -> id
          },
        ),
      ])
    }
  }
}
```
