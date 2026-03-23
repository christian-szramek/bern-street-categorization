# Automation of Bern Street Categorization

## Test Strategy

### Unit Tests

- Unit tests for Lua scripts using luaunit
- Test correctness of functions (is_highway, is_area_highway, is_area, ...) separated from the osm2pgsql I/O
- Exit criterium: 100% code coverage

### Integration Tests

- Manually verify:
  - \*.osm.pbf got downloaded/created
  - \*.osm.pbf got imported inside PostgreSQL with POSTGIS extension and deleted afterwards
  - OSM elements of the correct area are displayed on the Web UI

### E2E Tests

#### Correctness

- Manually select 10 streets per infrastructure type from OSM and verify that these streets get displayed in the Web UI with the correct infrastructure type assigned

#### Completeness

##### Test Data without highway key

- Node: 2284200952
- Way: 1077730959
- Way with area=yes: 312781570
- Relation: 9252024

#### Portability

- Manually process the following cities and verify that the tool doesn't crash and the Web UI displays infrastructure types:
  - Weimar (Small city)
  - Kopenhagen (Medium city, bicycle-friendly, non-dach)
  - Berlin (Large city)
