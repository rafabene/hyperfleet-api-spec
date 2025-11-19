import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "../models/statuses/model.tsp";
import "../models/common/model.tsp";
import "../models/nodepools/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;
@route("/clusters/{cluster_id}/statuses")
//@tag("Cluster statuses")
interface ClusterStatuses{
  /**
   * Returns adapter status reports for this cluster
   */
  @route("")
  @get
  @summary("List all adapter statuses for cluster")
  @operationId("getClusterStatuses")
  getClusterStatuses(
    /**
     * Cluster ID
     */
     @path cluster_id: string,
    ...QueryParams
  ): Body<AdapterStatusList> | NotFoundResponse;

  /**
   * Adapter creates or updates its status report for this cluster.
   * If adapter already has a status, it will be updated (upsert by adapter name).
   *
   * Response includes the full adapter status with all conditions.
   * Adapter should call this endpoint every time it evaluates the cluster.
   *
   */
  @route("")
  @post
  @summary("Create or update adapter status")
  @operationId("postClusterStatuses")
  postClusterStatuses(
    /**
     * Cluster ID
     */
     @path cluster_id: string,

    @body body: AdapterStatusCreateRequest,
  ):
    | (CreatedResponse & AdapterStatus)
    | BadRequestResponse
    | NotFoundResponse
    | ConflictResponse;

}

//@tag("NodePool statuses")
@route("/clusters/{cluster_id}/nodepools/{nodepool_id}/statuses")
interface NodePoolStatuses{
  /**
   * Returns adapter status reports for this nodepool
   */
  @route("")
  @get
  @summary("List all adapter statuses for nodepools")
  @operationId("getNodePoolsStatuses")
  getNodePoolsStatuses(
    /**
     * Cluster ID
     */
     @path cluster_id: string,
     @path nodepool_id: string,
    ...QueryParams
  ): Body<AdapterStatusList> | Error;

  /**
   * Adapter creates or updates its status report for this nodepool.
   * If adapter already has a status, it will be updated (upsert by adapter name).
   *
   * Response includes the full adapter status with all conditions.
   * Adapter should call this endpoint every time it evaluates the nodepool.
   *
   */
  @route("")
  @post
  @summary("Create or update adapter status")
  @operationId("postNodePoolStatuses")
  postNodePoolStatuses(
    /**
     * Cluster ID
     */
     @path cluster_id: string,
     @path nodepool_id: string,

    @body body: AdapterStatusCreateRequest,
  ):
    | (CreatedResponse & AdapterStatus)
    | BadRequestResponse
    | NotFoundResponse
    | ConflictResponse;

}
