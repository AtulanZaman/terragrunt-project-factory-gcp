
/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */



/*******************************************
  Create Terragrunt Folder under org
 *******************************************/

resource "google_folder" "Terragrunt" {
  display_name = "Terragrunt_Test"
  parent       = var.parent
}

/**********************************************
  Create Team folders under Terragrunt Folder 
 *********************************************/
resource "google_folder" "team1" {
  display_name = "team1"
  parent       = google_folder.Terragrunt.id
}

resource "google_folder" "team2" {
  display_name = "team2"
  parent       = google_folder.Terragrunt.id
}

/*******************************************
  Project creation
 *******************************************/

resource "random_id" "server" {
  byte_length = 3
}


resource "google_project" "seed_project" {
  name                = "terragrunt-seedproject-1"
  project_id          = "terragrunt-seedproject-${random_id.server.hex}"
  folder_id           = google_folder.Terragrunt.name
  billing_account     = var.billing_account
  auto_create_network = "false"
}

resource "google_storage_bucket" "tf_state_bkt" {
  project                     = google_project.seed_project.project_id
  name                        = "terragrunt-iac-core-bkt-${random_id.server.hex}"
  location                    = var.default_region
  force_destroy               = true
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }

}

resource "local_file" "packer-vars" {
  content = templatefile("root.yaml.tpl", {
    ROOT_PROJECT = google_project.seed_project.project_id
    GCS_BUCKET   = google_storage_bucket.tf_state_bkt.name
    REGION       = var.default_region
  })
  filename = "../root.yaml"
}