#!/bin/bash

for i in {1..200}
do
	##random client ip address for x_forwarded_for
	xff_ip=`printf "%d.%d.%d.%d\n" "$((RANDOM % 256))" "$((RANDOM % 256))" "$((RANDOM % 256))" "$((RANDOM % 256))"`
	useragent=('Mozilla/5.0' 'AppleWebKit/537.36' 'Chrome/75.0' 'Safari/537.36' 'Mozilla/5.5' 'Firefox/40.0' 'Internet Explorer' 'Mozilla/5.0' 'MS Edge/1.15' 'Safari/604.1' 'Mozilla/5.3' 'Chrome/72.0' 'Mobile Safari/537.36' 'Opera/2.0')
	##sampel uuid_v4
        x_id=('10abd23c-6ebf-4d67-a4bf-6c8c650fe9b7' '9b014524-bcf6-4073-9108-f87d6f581091' '51eedc56-beec-4729-8e38-6b1f1b74d43a' '18f0d0fb-0fe1-4601-8e7b-60ca6d8ff9a3' '370d4f58-1c97-4a60-a6d7-d059448f3254' '253b26eb-5221-472e-a002-0082def99e7c' '6375712b-5fb3-4ab7-bb53-96da85b7ea45' '584e70f0-dd5c-431c-b4bb-fe64cd05e91b' '6878d6fa-14b1-4e84-b278-93e4d4910857' '6c719c3f-0da3-4f09-b218-c50c887cd4d1' 'f831176e-5aad-4571-bd4a-e911e5f4e9e8' '6bd3207d-b4fe-48a8-a829-5a02afecae6a' 'c5ee7822-e816-4cda-96d1-2e9c5699b5a6' '2b1cbd4f-c9cb-4e34-97e0-3b39ac76971c' 'f82c7bdf-ff17-4ab3-94ee-9a06d39314b8' 'fc7181f5-8922-47d8-8e1b-39a267472cd5' 'c97be6d4-28bf-4698-afce-0dbf96111265' 'eab7675c-0822-45ea-8238-32de05469348' 'b71cf9d5-a7ba-4988-8d7e-c888dd0eefce' '34462811-3fff-49ae-9ab9-f8bcef275f3a' '1bbd9436-86a9-4617-85e1-664bfada7487' 'dd07ea66-923d-42e3-ae6d-5b72171bec63' 'd71006df-2b74-4824-9707-908fa1bcdb87' '32ff3d85-bede-4c7a-ab23-7ab989535ffa' '64becb6f-b6c1-4e38-8267-7bbff2145280' '6a269b15-e663-410b-bba9-f4cd423c4e86' '1c99017f-ca35-4fa4-8888-19bc700da971' '915a991f-eacf-42e8-9997-e879d265448a' '4807a95f-08aa-42d4-b67c-3055f6545770' '5f14db45-e1ae-4617-a521-27f17e99f1ac' '7dd34af4-2e6e-440d-aecb-edd782b9d9ff' '6434f0a5-f8c2-4473-915a-457da4a26cb3' 'ccb1b763-123e-427f-82af-fef92d9625ff' '79f83432-8de0-42b7-851a-6f2818df76ea' '82a9b4a9-0209-4241-9d64-42115612fc65' 'a5e3ba4d-e313-4f63-a516-4dee673dfad7' '67b21d17-e8ae-4750-9c2d-58cd08028846' 'bda7d522-469f-4daf-b168-8001b5168fdb' '6186ae33-d873-492e-8b99-3ec6627a21fd' '3de41bb3-d592-4002-94f6-df6c19425a16' 'ef32ce64-1d6e-4231-9a03-4783f73db3b1' '8de2a0a7-3ebe-435e-9a00-4bd8a08894e5' 'bd260b70-68e7-4162-9165-e01cfdc0c2c9' 'cce3cb80-99af-46b7-a527-b07aa3ef769f' 'cb2cd944-9e54-48ed-b66a-0148f10476c4' 'a24c118c-a884-4cb1-8036-c772122693c2' 'fa82ca7b-29dc-4d62-9299-b593ed0f09b1' '0faed674-9f57-4c1a-9042-415f24c9bbb7' 'a04d4888-d3cf-49c6-ba4f-bd13f1bdbbc7' '62c0bf9c-dd9e-4ede-bd9e-056da370d409' 'd56378cc-73a3-45d7-b6ed-94c72d3d9118' '81bc63be-38d3-4abc-8680-eca00e3341bd' 'e3e12460-16bc-407f-8e36-7f62607d48c2' '3a35870a-5a54-4891-8d9c-a722e8dadb49' 'ccc22992-c151-4f30-a6cd-24189ee9cb9e' '8506aa81-45a4-45f3-b0ea-bf68a403f2f1' '77c4cb18-fa98-4a4a-8dc9-b5ac5787f12c' 'fbeb89ed-fbeb-4979-9e51-0e64ba9dc1d7' 'fa1a5295-bba7-4d56-8e0d-359ecbe520de' '578666ee-079b-45b4-a48e-f82746c7f338' '582f4f93-f87a-48b2-b75c-451435c4539e' 'dbc882a9-0f33-4232-a9fe-8eb37f773c95' '88deb272-a9da-47b7-9f4d-f9f10d7b14c0' 'b2cae3bc-34f8-4100-a069-96793f2f9611' '0079ac5e-32f7-4805-8720-07b22bfd7d9a' '52927f75-420a-4bc1-8b42-ef8f23cbbac0' 'ff27a802-c2e4-4325-b20a-6a72ff38161b' '71603e0c-9217-4a1b-94e6-fef3b800a467' '05c30772-e511-49bb-9d56-d201ee3dab47' '6df66f92-8024-43d1-b1e3-36fae84e2ef0' 'e89d328f-ba09-4d27-bdfe-25253b8e47b0' '0fe4afa0-2cd6-4b46-bd2d-06ea5483f0e7' '161b3797-810a-4b12-8e52-ed1f5ebf7a6c' '7221fae4-e63a-445c-a48e-7b07d6028112' 'a7cbc5d4-32ba-4be6-b33b-948f9254856d' 'e7766b7a-7d08-40b0-83cc-63f53a913083')

        #take a value from useragent and x_id array
	seed=`echo "$(od -An -N4 -tu4 /dev/urandom) % 6" | bc`
	uagent=${useragent[`echo "$seed % 20" | bc`]}
	id=${x_id[`echo "$seed % 20" | bc`]}

	#run curl queries
	curl -k -H "user-agent: $uagent" -H "X-Request-ID: $id" https://bookinfo.f5se.io
	curl -k -H "user-agent: $uagent" -H "X-Request-ID: $id" https://bookinfo.f5se.io/productpage?u=normal 
	curl -k -H "user-agent: $uagent" -H "X-Request-ID: $id" https://bookinfo.f5se.io/productpage?u=test
	echo "---- $i ---- $xff_ip ---------"
	sleep 1

done
