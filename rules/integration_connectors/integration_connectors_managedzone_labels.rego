# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

########################################################################
# DETAILS:  Check to verify must-have labels on resource
# SEVERITY: Medium
# ASSET_TYPE: connectors.googleapis.com/ManagedZone
# TAGS: Labeling, Compliance, Cost, Integrator Connectors
########################################################################

package google.connectors.managedzone.labels

import data.validator.google.lib as lib
import data.validator.google.lib.parameters as gparam
import future.keywords

asset := input.asset

params := lib.get_default(gparam.global_parameters, "integrator_connectors", {})

deny [{"msg": message, "details": metadata}] {

	# Check if resource is in exempt list
	exempt_list := lib.get_default(params, "exemptions", [])
	exempt := {asset.name} & {ex | ex := exempt_list[_]}
	not count(exempt) != 0

	labels := lib.get_default(asset.resource.data, "labels", {})
	must_have_labels := lib.get_default(gparam.global_parameters, "must_have_labels", {})

	message:= lib.check_label(labels,must_have_labels)
	message != ""

	metadata:= {"name": asset.name}
}
