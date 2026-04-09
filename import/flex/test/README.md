# Test Setup

You can perform two kind of tests. The unit tests call the _get_infrastructure_type(tags, restriction)_ function of the [infrastructure_logic.lua](../infrastructure_logic.lua) with real world street segments of Bern and Berlin for each infrastructure type. With the E2E tests you can test the whole processing flow, from creating and populating the database tables to visualizing the street segment in the frontend. Real worl street segments from Bern and Berlin for each infrastructure type were used as well to create _osm.pbf_ files like the ones that would be downloaded from Geofabrik. The expected features you can verify are listed below.

## Unit Tests

1. Install and setup the unit test dependencies:

```sh
sudo apt install lua5.3 liblua5.3-dev luarocks libexpat1-dev
```

```sh
sudo luarocks install luaexpat
```

2. Add the following to the end of the .bashrc:

```text
eval "$(luarocks path)"
```

3. Source the .bashrc:

```sh
source ~/.bashrc
```

4. Navigate to the unit test directory:

```sh
cd import/flex/test
```

5. Execute the tests:

```sh
./luarocks test
```

## E2E Test

1. Change the `TEST` variable in the .env file to _true_
2. Execute the `./process.sh` script if it was never run before, otherwise execute the `./rerun.sh` script
3. Verify that the following street segments with it's IDs are displayed correctly in the frontend. If there is a _B_ after the ID, you have to check this street segment in Berlin:

- Street with bicycle forbidden
  - 1 lane
    - 23586279
    - 39236046
    - 4224524
  - 2 lane
    - 39236051
    - 37012309
    - 184719741
  - 3 lane
    - 23633764
    - 184719742
    - 1118859711
  - 4 lane
    - 442281792
    - 442313523
    - 968944897
  - 5 lane
    - 322543959 B
    - 458363339 B
    - 66289209 B
- Street with bus/bicycle lane on one side
  - 1 lane
    - 4886824
    - 40263983
    - 890980058
  - 2 lane
    - 544738943
    - 200213225
    - 195736528
  - 3 lane
    - 160248344
    - 122977868
    - 1173057691
  - 4 lane
    - 25463644
    - 509946427
    - 314222543
  - 5 lane
    - 130964457
    - 442269538
- Street with bus/bicycle lane on both sides
  - 1 lane
    - 172645205
    - 385402046
    - 67484509
  - 2 lane
    - 38589360
    - 180296584
    - 116648001
  - 3 lane
    - 91560374
    - 48846008
    - 561878178
  - 4 lane
    - 219927154
    - 558587989
    - 707254590
  - 5 lane
    - 667913239
    - 48162953
    - 339294553
  - 6 lane
    - 25388032
    - 25388023
    - 338526890
- Street with separate bicycle lane on sidepath
  - 1 lane
    - 44811942
    - 759036249
    - 759036248
  - 2 lane
    - 558460732
    - 777427921
    - 742674473
  - 3 lane
    - 1156619538
    - 510707671
  - 4 lane
    - 50055298
    - 1265102103
    - 4817433
  - 5 lane
    - 318210360 B
    - 1430193943 B
    - 1152249198 B
  - 6 lane
    - 1173920337 B
    - 332164879 B
    - 1101200759 B
  - 7 lane
    - 183621692 B
    - 9835413 B
- Street with bus/bicycle lane and separate bicycle lane on sidepath
  - 1 lane
    - 28812707 B
    - 492567356 B
    - 37638502 B
  - 2 lane
    - 534130897
    - 966520397
    - 1156619534
  - 3 lane
    - 80706109 B
    - 1466764435 B
    - 1175826795 B
  - 4 lane
    - 569095264
    - 188142789
    - 307351478
  - 5 lane
    - 313917246 B
    - 71001582 B
    - 1133993746 B
  - 6 lane
    - 1199295115 B
    - 29565645 B
    - 1082762757 B
- Separate bicycle lane on sidepath (marked as extra way)
  - 229321135 B
  - 22294245 B
  - 866877254 B
- Street with shared bicycle lane on carriageway
  - 1 lane
    - 22278168 B
    - 72175275 B
    - 1430847472 B
  - 2 lane
    - 44278347
    - 515833205
    - 585349949
  - 3 lane
    - 563411995
    - 849507248
    - 570658232
- Street with no bicycle paths
  - 1 lane
    - 225399179
    - 4862762
    - 40992518
  - 2 lane
    - 116025746
    - 549219919
    - 4872845
  - 3 lane
    - 569029613
    - 560823045
    - 535365592
  - 4 lane
    - 4877893
    - 1116817903
    - 59355694
  - 5 lane
    - 301883988
    - 1116817904
    - 48124533
  - 6 lane
    - 340966773 B
    - 331762106 B
    - 4555271 B
  - 7 lane
    - 22955115 B
    - 397859392 B
- One-way street with bus/bicycle lane on one side
  - 1 lane
    - 536759236
    - 219953853
    - 536759234
  - 2 lane
    - 543954401
    - 57838140
    - 160247839
  - 3 lane
    - 509868655
    - 132046618
    - 1118859710
  - 4 lane
    - 58591660
    - 58591662
    - 509880232
  - 5 lane
    - 335393888 B
    - 26285705 B
    - 1394173373 B
- One-way street with bus/bicycle lane on both sides
  - 1 lane
    - 26758252
    - 1056699725
    - 37766457
  - 2 lane
    - 443675315
    - 442269558
    - 566451223
  - 3 lane
    - 974996812
    - 132150332
- One-way street with separate bicycle lane on sidepath
  - 1 lane
    - 75376543
    - 180296578
    - 75652078
  - 2 lane
    - 337805509
  - 3 lane
    - 42878063 B
    - 1156852904 B
    - 1101187162 B
  - 4 lane
    - 1104356822 B
    - 422923714 B
    - 1084962178 B
  - 5 lane
    - 982221216 B
    - 25394871 B
    - 1133397571 B
  - 6 lane
    - 29277837 B
    - 1311315167 B
    - 969851408 B
- One-way street with bus/bicycle lane and separate bicycle lane on sidepath
  - 1 lane
    - 4878031
    - 706626514
    - 5077399
  - 2 lane
    - 1395760170
  - 3 lane
    - 335487070 B
    - 1126172853 B
    - 31969210 B
- One-way street with no bicycle paths
  - 1 lane
    - 48891852
    - 23455682
    - 48015959
  - 2 lane
    - 94231675
    - 50055270
    - 653723627
  - 3 lane
    - 307346873
    - 23584525
    - 725344347
  - 4 lane
    - 490356855 B
    - 47951636 B
    - 1136651933 B
  - 5 lane
    - 332573582 B
    - 61820398 B
    - 323528046 B
- Bicycle road
  - 717177006 B
  - 981295184 B
  - 1460786454 B
- Cycleway
  - 549017557
  - 1426724026
  - 1069981966
- Cycleway multiuse
  - 1415473411
  - 1421702999
  - 9421118
- Cyclist waiting aid
  - 10265532955 B
  - 13023132208 B
  - 8701749195 B
- Mainly/exclusively for pedestrian
  - 536453654
  - 652499475
  - -10430209
- Mainly/exclusively for pedestrian with bicycle allowed
  - 453816462
  - 160523653
  - 96207433
- Crossing (bicycle, pedestrian, horserider)
  - 453245916
  - 3339477472
  - 5302265579
- Uncategorized
  - 1370384520
  - 37231307
  - 1414952521
- Invalid Data (no highway key)
  - Node: 2284200952
  - Way: 1077730959
  - Way with area=yes: 312781570
  - Relation: 9252024
