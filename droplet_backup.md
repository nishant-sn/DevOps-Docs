```
#!/bin/bash
set -o errexit

##########   Set URL   ############
BASE="https://api.digitalocean.com"
DENDPOINT="/v2/droplets"
URL="${BASE}${DENDPOINT}"

##########   Content Type    ##########
MA="Authorization: Bearer xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
MH="Content-Type: application/json"

Take_Snapshot() {
   for id in xxxxxxx xxxxxxxx xxxxxxx
      do
	########## Getting Droplet Name   ###########
     	GN=$(curl -X GET -H "${MH}" -H "${MA}" "${URL}/${id}" | jq ".droplet.name" | tr -d '"')
     	now="$(date +'%d-%m-%Y')"
     	NAME="${GN}-${now}"
	##########  Create Snapshot   ##########
     	curl -X POST -H 'Content-Type: application/json' -H "${MA}" -d '{"type":"snapshot","name":"'"$NAME"'"}' "${URL}/${id}/actions"
      done
}

Take_Snapshot
```