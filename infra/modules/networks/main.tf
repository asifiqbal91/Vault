resource "docker_network" "public" {
  name            = "public"
  driver          = "bridge"
  attachable      = true
}

resource "docker_network" "kitchen" {
  name            = "kitchen"
  driver          = "bridge"
  internal        = true
}
