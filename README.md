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

- 1. Download all highways with overpass API
- 2. Filter out highway elements that shouldn't be displayed (nodes, highway:area)
- 3. Verify that every element is displayed in the Web UI
- 4. Verify that every element has an infrastructure_type property

#### Portability

- Manually process the following cities and verify that the tool doesn't crash and the Web UI displays infrastructure types:
  - Weimar (Small city)
  - Kopenhagen (Medium city, bicycle-friendly, non-dach)
  - Berlin (Large city)
