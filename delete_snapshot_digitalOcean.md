```
#!/bin/bash
set -o errexit

##########   Set URL   ############
BASE="https://api.digitalocean.com"
DENDPOINT="/v2/droplets/"
URL="${BASE}${DENDPOINT}"

MA="Authorization: Bearer xxxxxxxxxxxxxxxx"
MH="Content-Type: application/json"

###############   Get n days back date  #################
old="$(date --date="n days ago" +"%d"-"%m"-"%Y")"

############  Delete Function  ####################
Delete_Snapshot() {
   for id in xxxxxxx  xxxxxx
      do

        ##########   Get Droplet Name   ##########
        GN=$(curl -X GET -H "${MH}" -H "${MA}" "${URL}${id}" | jq ".droplet.name" | tr -d '"')
	OLDSN="${GN}-${old}"

	############# Get Snapshot ID #############
        SNAPID=$(curl -X GET -H "${MH}" -H "${MA}" -d '{"type":"snapshot", "name": "'"$OLDSN"'"}' "${BASE}/v2/snapshots"| jq ".snapshots[0].id" | tr -d '"')
        
	############# Delete Snapshot ##############
        curl -X DELETE -H "${MH}" -H "${MA}" "${BASE}/v2/snapshots/${SNAPID}"

      done
}

Delete_Snapshot


```