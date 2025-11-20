import "../common/model.tsp";
import "./example_adapter_status.tsp";

/**
 * Condition represents a single status condition
 * Used in both AdapterStatus.conditions[] (with standard types like "Available")
 * and ClusterStatus.conditions[] (with semantic types like "ValidationSuccessful", "DNSSuccessful", etc.)
 */
model Condition {
  /**
   * Condition type
   * In AdapterStatus: Standard Kubernetes types ("Available", "Applied", "Health")
   * In ClusterStatus: Semantic types ("ValidationSuccessful", "DNSSuccessful", "NodePoolSuccessful", etc.)
   */
  type: string;

  /**
   * Condition status
   */
  status: "True" | "False" | "Unknown";

  /**
   * Machine-readable reason code
   */
  reason?: string;

  /**
   * Human-readable message
   */
  message?: string;

  /**
   * Generation of the spec that this condition reflects
   */
  observed_generation: int32;

  /**
   * When this condition was first created (API-managed)
   */
  @format("date-time") created_time: string;

  /**
   * When this condition was last updated (API-managed)
   */
  @format("date-time") last_updated_time: string;

  /**
   * When this condition last transitioned status (API-managed)
   */
  @format("date-time") last_transition_time?: string;
}

/**
 * Condition data for create/update requests (from adapters)
 */
model ConditionRequest {
  type: string;
  status: "True" | "False" | "Unknown";
  reason?: string;
  message?: string;
  observed_generation: int32;

  /**
   * When the adapter observed this condition
   * API will use this to set created_time, last_updated_time, last_transition_time
   */
  @format("date-time") observed_time: string;
}

/**
 * AdapterStatus represents the complete status report from an adapter
 * Contains multiple conditions, job metadata, and adapter-specific data
 */
@example(exampleAdapterStatus)
model AdapterStatus {
  /**
   * Adapter name (e.g., "validator", "dns", "provisioner")
   */
  adapter: string;

  /**
   * Which generation of the resource this status reflects
   */
  observed_generation: int32;

  /**
   * Kubernetes-style conditions tracking adapter state
   * Typically includes: Available, Applied, Health
   */
  conditions: Condition[];

  /**
   * Job execution metadata
   */
  metadata?: {
    job_name?: string;
    job_namespace?: string;
    attempt?: int32;
    @format("date-time") started_time?: string;
    @format("date-time") completed_time?: string;
    duration?: string;
  };

  /**
   * Adapter-specific data (structure varies by adapter type)
   */
  data?: Record<unknown>;

  /**
   * When this adapter status was first created (API-managed)
   */
  @format("date-time") created_time: string;

  /**
   * When this adapter status was last updated (API-managed)
   */
  @format("date-time") last_updated_time: string;
}

/**
 * Request payload for creating/updating adapter status
 */
@example(exampleAdapterStatusCreateRequest)
model AdapterStatusCreateRequest {
  adapter: string;
  observed_generation: int32;
  conditions: ConditionRequest[];
  metadata?: {
    job_name?: string;
    job_namespace?: string;
    attempt?: int32;
    @format("date-time") started_time?: string;
    @format("date-time") completed_time?: string;
    duration?: string;
  };
  data?: Record<unknown>;
}

/**
 * List of adapter statuses with pagination metadata
 */
@example(exampleAdapterStatusList)
model AdapterStatusList extends List {
  kind: "AdapterStatusList";
  items: AdapterStatus[];
}
