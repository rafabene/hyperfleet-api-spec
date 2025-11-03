# HyperFleet OpenAPI spec

This project hosts the TypeSpec files to generate the HyperFleet OpenAPI specifications. The repository is organized to support multiple service variants (core, GCP, etc.) while sharing common models and interfaces.

## Repository Structure

The repository is organized into three main directories:

### `/services`
Contains service definitions that generate the OpenAPI specifications. Each service has its own `main.tsp` file and `tspconfig.yaml` configuration.

- **`services/core/`** - Core HyperFleet API service definition
  - Uses provider-agnostic `ClusterSpec` (Record<unknown>)
  - Output: `tsp-output/schema/openapi.yaml`

- **`services/gcp/`** - GCP-specific HyperFleet API service definition
  - Uses GCP-specific `GCPClusterSpec` model
  - Output: `tsp-output/@typespec/openapi3/openapi.yaml`

### `/shared`
Contains shared modules used by all service variants:

- **`shared/clusters/`** - Cluster resource definitions (interfaces and base models)
- **`shared/statuses/`** - Status resource definitions for clusters and nodepools
- **`shared/nodepools/`** - NodePool resource definitions
- **`shared/compatibility/`** - Compatibility endpoints
- **`shared/common/`** - Common models and types (APIResource, Error, QueryParams, etc.)

### `/providers`
Contains provider-specific model definitions that override shared types:

- **`providers/core/model.tsp`** - Defines `ClusterSpec` as `Record<unknown>` (generic)
- **`providers/gcp/model.tsp`** - Defines `ClusterSpec` as `GCPClusterSpec` (GCP-specific)

## Building OpenAPI Specifications

Each service has its own configuration and can be built independently:

### Build Core Service
```bash
tsp compile services/core/main.tsp
```

### Build GCP Service
```bash
tsp compile services/gcp/main.tsp
```

## Architecture

The HyperFleet API provides simple CRUD operations for managing cluster resources and their status history:

- **Simple CRUD only**: No business logic, no event creation
- **Sentinel operator**: Handles all orchestration logic
- **Adapters**: Handle the specifics of managing provider-specific specs

## Adding a New Provider

To add a new provider (e.g., AWS):

1. Create provider model: `providers/aws/model.tsp`
   ```typescript
   model AWSClusterSpec {
     awsProperty1: string;
     awsProperty2: string;
   }
   
   alias ClusterSpec = AWSClusterSpec;
   ```

2. Create service definition: `services/aws/main.tsp`
   ```typescript
   import "../../providers/aws/model.tsp";
   import "../../shared/clusters/";
   import "../../shared/statuses/";
   // ... other shared imports
   ```

3. Create service config: `services/aws/tspconfig.yaml` (copy from existing service)

## Adding a New Service Variant

To create a new service variant (e.g., with additional endpoints):

1. Create new directory: `services/variant-name/`
2. Copy `main.tsp` and `tspconfig.yaml` from an existing service
3. Modify the service definition as needed
4. Import shared modules and appropriate provider models

## Dependencies

- `@typespec/compiler` - TypeSpec compiler
- `@typespec/http` - HTTP protocol support
- `@typespec/openapi` - OpenAPI decorators
- `@typespec/openapi3` - OpenAPI 3.0 emitter
